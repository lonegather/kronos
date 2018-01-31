# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
import uuid

from django.db import models
from django.contrib.auth.models import User
from django.utils.encoding import python_2_unicode_compatible


@python_2_unicode_compatible
class Department(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50, default='company')
    info = models.CharField(max_length=50, default='company')

    def __str__(self):
        return self.info


@python_2_unicode_compatible
class Role(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50, default='artist')
    info = models.CharField(max_length=50, default='artist')

    def __str__(self):
        return self.info


@python_2_unicode_compatible
class Profile(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=50, default='artist')
    role = models.ForeignKey(Role, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)

    def __str__(self):
        return 'User Information'


@python_2_unicode_compatible
class Project(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=200, blank=True)
    fps = models.IntegerField(default=25)
    camera = models.CharField(max_length=50, default='MainCAM')
    url = models.CharField(max_length=200, default='/')

    @classmethod
    def all(cls, *_, **__):
        result = []
        for prj in cls.objects.all():
            if prj.name == '|':
                continue
            result.append({'id': str(prj.id), 'name': prj.name, 'info': prj.info})
        return result
    
    def __str__(self):
        return self.name
    

@python_2_unicode_compatible
class Edition(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    url_head = models.CharField(max_length=200, blank=True)
    url_history = models.CharField(max_length=200, blank=True)
    
    def __str__(self):
        return self.name
    

@python_2_unicode_compatible
class Genus(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=10)
    info = models.CharField(max_length=50, blank=True)
    url = models.CharField(max_length=200, blank=True)
    
    def __str__(self):
        return self.name
    

@python_2_unicode_compatible
class Tag(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    genus = models.ForeignKey(Genus, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    url = models.CharField(max_length=200, blank=True)

    @classmethod
    def get(cls, **kwargs):
        result = []
        keywords = {}
        mapper = {'project': 'project__name',
                  'genus': 'genus__name',
                  }
        for key in kwargs:
            if key in mapper:
                keywords[mapper[key]] = kwargs[key]
            else:
                keywords[key] = kwargs[key]
        for tag in cls.objects.filter(**keywords):
            result.append({'name': tag.name, 'info': tag.info, 'project': tag.project.name,
                           'genus': tag.genus.name, 'genus_info': tag.genus.info})
        return result
    
    def __str__(self):
        return self.name if self.project.name == '|' else '%s | %s' % (self.project, self.name)


@python_2_unicode_compatible
class Entity(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, default=uuid.uuid4, on_delete=models.CASCADE)
    tag = models.ForeignKey(Tag, default=uuid.uuid4, on_delete=models.CASCADE)
    link = models.ManyToManyField("Entity", blank=True)
    name = models.CharField(max_length=100)
    info = models.CharField(max_length=200, blank=True)
    url = models.CharField(max_length=200, blank=True)
    thumb = models.ImageField(upload_to="thumbs", default="thumbs/default.png")

    @classmethod
    def get(cls, **kwargs):
        result = []
        keywords = {}
        mapper = {'project': 'project__name',
                  'genus': 'tag__genus__name',
                  }
        for key in kwargs:
            if key in mapper:
                keywords[mapper[key]] = kwargs[key]
            else:
                if key == 'id':
                    keywords[key] = uuid.UUID(kwargs[key])
                else:
                    keywords[key] = kwargs[key]
        for ent in cls.objects.filter(**keywords):
            link = []
            for l in ent.link.all():
                link.append(str(l.id))

            result.append({'id': str(ent.id), 'project': ent.project.name,
                           'name': ent.name, 'info': ent.info,
                           'genus': ent.tag.genus.name, 'genus_info': ent.tag.genus.info,
                           'tag': ent.tag.name, 'tag_info': ent.tag.info,
                           'link': link, 'path': ent.path(), 'thumb': ent.thumb.url,
                           })
        return result

    @classmethod
    def get_by_id(cls, id_list):
        result = []
        id_list = json.loads(id_list)
        for i in id_list:
            link = []
            ent = cls.objects.get(id=i)
            for l in ent.link.all():
                link.append(str(l.id))
            result.append({'id': str(ent.id), 'name': ent.name, 'info': ent.info,
                           'genus': ent.tag.genus.name, 'genus_info': ent.tag.genus.info,
                           'tag': ent.tag.name, 'tag_info': ent.tag.info,
                           })
        return result

    @classmethod
    def set(cls, form):
        ent_id = form.get('id', [None])[0]
        tag = Tag.objects.get(name=form['tag'][0])

        if ent_id:
            ent = Entity.objects.get(id=ent_id)
            ent.name = form['name'][0]
            ent.info = form['info'][0]
            ent.url = ent.name
            ent.tag = tag
            ent.link.clear()
            for link_id in form.get('link', []):
                link = Entity.objects.get(id=link_id)
                ent.link.add(link)
        else:
            prj = Project.objects.get(id=form['project'][0])
            ent = Entity(project=prj, tag=tag,
                         name=form['name'][0], info=form['info'][0],
                         url=form['name'][0])
            ent.save()
            for link_id in form.get('link', []):
                link = Entity.objects.get(id=link_id)
                ent.link.add(link)

        if 'thumb' in form:
            ent.thumb = form['thumb']

        ent.save()
    
    def genus(self):
        return self.tag.genus

    def path(self):
        project = self.project.url
        tag = self.tag.url
        genus = self.tag.genus.url
        edition = Edition.objects.get(name='publish').url_head
        entity = self.url
        result = {}
        for stage_obj in Stage.objects.filter(genus=self.tag.genus, project=self.project):
            stage = stage_obj.url
            result[stage_obj.name] = stage_obj.path.format(**locals())
        return result
    
    def save(self, *args, **kwargs):
        if self.genus().name == 'batch':
            tags = Tag.objects.filter(name=self.name, project=self.project)
            if len(tags):
                return
            
            genus = Genus.objects.get(name='shot')
            data = {'name':    self.name,
                    'project': self.project,
                    'genus':   genus,
                    'info':    self.name,
                    'url':     self.name}
            Tag(**data).save()
            
        models.Model.save(self, *args, **kwargs)
        
    def delete(self, using=None, keep_parents=False):
        if self.genus().name == 'batch':
            Tag.objects.get(project=self.project, name=self.name).delete()
        
        return models.Model.delete(self, using=using, keep_parents=keep_parents)
    
    def __str__(self):
        name = str(self.name)
        project = str(self.project)
        tag = str(self.tag.name)
        return '{name} [ {project} | {tag} ]'.format(**locals())


@python_2_unicode_compatible
class Stage(models.Model):

    @classmethod
    def get(cls, **kwargs):
        result = []
        keywords = {}
        mapper = {'project': 'project__name',
                  'genus': 'genus__name',
                  }
        for key in kwargs:
            if key in mapper:
                keywords[mapper[key]] = kwargs[key]
            else:
                keywords[key] = kwargs[key]
        for stg in cls.objects.filter(**keywords):
            result.append({'name': stg.name, 'info': stg.info, 'project': stg.project.name,
                           'genus': stg.genus.name, 'genus_info': stg.genus.info,
                           'path': stg.path})
        return result
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, default=uuid.uuid4, on_delete=models.CASCADE)
    genus = models.ForeignKey(Genus, default=uuid.uuid4, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    path = models.CharField(max_length=200, default='/')
    url = models.CharField(max_length=200, blank=True)
    
    def __str__(self):
        return self.name
    

@python_2_unicode_compatible
class Status(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    edition = models.ForeignKey(Edition, default=uuid.uuid4, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    
    def __str__(self):
        return self.name
    

@python_2_unicode_compatible
class Task(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    entity = models.ForeignKey(Entity, default=uuid.uuid4, on_delete=models.CASCADE)
    stage = models.ForeignKey(Stage, default=uuid.uuid4, on_delete=models.CASCADE)
    status = models.ForeignKey(Status, default=uuid.uuid4, on_delete=models.CASCADE)
    # entity = models.ForeignKey(Entity, default=uuid.uuid4, on_delete=models.CASCADE)
    
    def __str__(self):
        return '%s - %s' % (self.stage.name, self.entity)
