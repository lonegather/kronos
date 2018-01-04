# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
import uuid

from django.db import models
from django.utils.encoding import python_2_unicode_compatible


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
            result.append({'name': prj.name, 'info': prj.info})
        return json.dumps(result)
    
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
    
    def __str__(self):
        return self.name if self.project.name == '|' else '%s | %s' % (self.project, self.name)


@python_2_unicode_compatible
class Entity(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, default=uuid.uuid4, on_delete=models.CASCADE)
    tag = models.ForeignKey(Tag, default=uuid.uuid4, on_delete=models.CASCADE)
    link = models.CharField(max_length=200, blank=True)
    name = models.CharField(max_length=100)
    info = models.CharField(max_length=200, blank=True)
    url = models.CharField(max_length=200, blank=True)

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
        for ent in cls.objects.filter(**keywords):
            result.append({'name': ent.name, 'info': ent.info, 'project': ent.project.name,
                           'genus': ent.tag.genus.name, 'genus_info': ent.tag.genus.info,
                           'tag': ent.tag.name, 'tag_info': ent.tag.info,
                           'path': ent.path()})
        return json.dumps(result)
    
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
            data = {'name':        self.name,
                    'project':     self.project,
                    'genus':       genus,
                    'info':        self.name,
                    'url': '/%s' % self.name}
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
