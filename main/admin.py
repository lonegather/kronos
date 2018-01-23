# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from . import models

# Register your models here.


@admin.register(models.Project)
class ProjectAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info')
    list_filter = ('name', )
    ordering = ('name', )
    
    
@admin.register(models.Edition)
class EditionAdmin(admin.ModelAdmin):
    
    list_display = ('name', )
    ordering = ('name', )
    
    
@admin.register(models.Genus)
class GenusAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info')
    ordering = ('name', )
    

@admin.register(models.Tag)
class TagAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info')
    list_filter = ('project', )
    ordering = ('genus', )


@admin.register(models.Entity)
class EntityAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info', 'tag', 'genus', 'path', 'thumb')
    list_filter = ('project', 'tag')
    ordering = ('name', )
    search_fields = ('name', )
    
    
@admin.register(models.Stage)
class StageAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info', 'genus', 'path', 'project')
    list_filter = ('genus', 'project')
    ordering = ('name', )


@admin.register(models.Status)
class StatusAdmin(admin.ModelAdmin):
    
    list_display = ('name', 'info')
    ordering = ('name', )


@admin.register(models.Task)
class TaskAdmin(admin.ModelAdmin):
    
    list_display = ('entity', 'stage', 'status')
    ordering = ('entity', )
    search_fields = ('entity', )

