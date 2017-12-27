# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import uuid
from django.db import models

# Create your models here.
class Project(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=200, blank=True)
    fps = models.IntegerField(default=25)
    camera = models.CharField(max_length=50, default='MainCAM')
    url = models.CharField(max_length=200, default='/')
    
    def __str__(self):
        return self.name
    
    
class Edition(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    url_head = models.CharField(max_length=200, default='/')
    url_history = models.CharField(max_length=200, default='/')
    
    def __str__(self):
        return self.name
    

class Genus(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=10)
    info = models.CharField(max_length=50, blank=True)
    url  = models.CharField(max_length=200, default='/')
    
    def __str__(self):
        return self.name
    
    
class Tag(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, on_delete=models.CASCADE)
    genus = models.ForeignKey(Genus, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    url = models.CharField(max_length=200, default='/')
    
    def __str__(self):
        return self.name if self.project.name == '|' else '%s | %s' % (self.project, self.name)


class Entity(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(Project, default=uuid.uuid4, on_delete=models.CASCADE)
    tag = models.ForeignKey(Tag, default=uuid.uuid4, on_delete=models.CASCADE)
    link = models.CharField(max_length=200, blank=True)
    name = models.CharField(max_length=100)
    info = models.CharField(max_length=200, blank=True)
    url = models.CharField(max_length=200, default='/')
    
    def genus(self):
        return self.tag.genus
    
    def __str__(self):
        name = str(self.name)
        project = str(self.project)
        tag = str(self.tag.name)
        return '{name} [ {project} | {tag} ]'.format(**locals())


class Stage(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    genus = models.ForeignKey(Genus, default=uuid.uuid4, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    subscriber = models.CharField(max_length=100, blank=True)
    path = models.CharField(max_length=200, default='/')
    url = models.CharField(max_length=200, default='/')
    
    def __str__(self):
        return self.name
    
    
class Status(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    edition = models.ForeignKey(Edition, default=uuid.uuid4, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    info = models.CharField(max_length=50, blank=True)
    
    def __str__(self):
        return self.name
    
    
class Task(models.Model):
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    entity = models.ForeignKey(Entity, default=uuid.uuid4, on_delete=models.CASCADE)
    stage = models.ForeignKey(Stage, default=uuid.uuid4, on_delete=models.CASCADE)
    status = models.ForeignKey(Status, default=uuid.uuid4, on_delete=models.CASCADE)
    #entity = models.ForeignKey(Entity, default=uuid.uuid4, on_delete=models.CASCADE)
    
    def __str__(self):
        return '%s - %s' % (self.stage.name, self.entity)
    
