# -*- coding: utf-8 -*-


def reset_data():
    from . import models
    
    try: print(uwsgi)
    except: pass
    
    tables = [models.Project, models.Edition, models.Genus, models.Tag, 
              models.Entity, models.Stage, models.Status, models.Task]
    
    for table in tables:
        for data in table.objects.all():
            data.delete()
    
    #Project
    for data in [{'name':'|'                                                          },
                 {'name':'PT | S02', 'info':u'哈喽葡星人 第二季', 'url':'file:///P:/PT/S02/'},
                 {'name':'MB | S01', 'info':u'百变布鲁可 第一季', 'url':'file:///P:/MB/S01/'},
                 ]: models.Project(**data).save()
    
    #Edition
    for data in [{'name':'work',    'url_head':'/work',    'url_history':'/history/work'   },
                 {'name':'publish', 'url_head':'/publish', 'url_history':'/history/publish'},
                 ]: models.Edition(**data).save()
    
    #Genus
    for data in [{'name':'asset', 'info':u'资产', 'url':'/assets'},
                 {'name':'shot',  'info':u'镜头', 'url':'/shots' },
                 {'name':'batch', 'info':u'批次', 'url':''       },
                 ]: models.Genus(**data).save()
    
    #Tag
    prj_all = models.Project.objects.get(name='|')
    gns_batch = models.Genus.objects.get(name='batch')
    gns_asset = models.Genus.objects.get(name='asset')
    for data in [{'project':prj_all, 'genus':gns_batch, 'name':'scene',   'info':u'场次', 'url':''      },
                 {'project':prj_all, 'genus':gns_batch, 'name':'episode', 'info':u'集数', 'url':''      },
                 {'project':prj_all, 'genus':gns_asset, 'name':'CH',      'info':u'角色', 'url':'/char' },
                 {'project':prj_all, 'genus':gns_asset, 'name':'PR',      'info':u'道具', 'url':'/prop' },
                 {'project':prj_all, 'genus':gns_asset, 'name':'SC',      'info':u'场景', 'url':'/scene'},
                 ]: models.Tag(**data).save()
    
    #Entity
    
    
    #Stage
    gns_shot = models.Genus.objects.get(name='shot')
    for data in [{'genus':gns_batch, 'name':'script',      'info':u'剧本', 'path':'{project}{stage}{entity}',                      'url':'/scp'},
                 {'genus':gns_batch, 'name':'storyboard',  'info':u'分镜', 'path':'{project}{stage}{entity}',                      'url':'/stb'},
                 {'genus':gns_batch, 'name':'dubbing',     'info':u'配音', 'path':'{project}{stage}{entity}',                      'url':'/dub'},
                 {'genus':gns_asset, 'name':'design',      'info':u'原画', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/dsn'},
                 {'genus':gns_asset, 'name':'modeling',    'info':u'建模', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/mdl'},
                 {'genus':gns_asset, 'name':'texture',     'info':u'贴图', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/txt'},
                 {'genus':gns_asset, 'name':'shader',      'info':u'材质', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/shd'},
                 {'genus':gns_asset, 'name':'rigging',     'info':u'绑定', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/rig'},
                 {'genus':gns_asset, 'name':'preview',     'info':u'预览', 'path':'{project}{edition}{genus}{tag}{entity}{stage}', 'url':'/prv'},
                 {'genus':gns_shot,  'name':'layout',      'info':u'布局', 'path':'{project}{edition}{genus}{tag}{stage}',         'url':'/lyt'},
                 {'genus':gns_shot,  'name':'animation',   'info':u'动画', 'path':'{project}{edition}{genus}{tag}{stage}',         'url':'/anm'},
                 {'genus':gns_shot,  'name':'cfx',         'info':u'解算', 'path':'{project}{edition}{genus}{tag}{stage}',         'url':'/cfx'},
                 {'genus':gns_shot,  'name':'lighting',    'info':u'灯光', 'path':'{project}{edition}{genus}{tag}{stage}',         'url':'/lgt'},
                 {'genus':gns_shot,  'name':'rendering',   'info':u'渲染', 'path':'{project}{edition}{genus}{tag}{stage}{entity}', 'url':'/rnd'},
                 {'genus':gns_shot,  'name':'vfx',         'info':u'特效', 'path':'{project}{edition}{genus}{tag}{stage}{entity}', 'url':'/vfx'},
                 {'genus':gns_shot,  'name':'compositing', 'info':u'合成', 'path':'{project}{edition}{genus}{tag}{stage}{entity}', 'url':'/cmp'},
                 ]: models.Stage(**data).save()
    
    #Status
    edt_work = models.Edition.objects.get(name='work')
    edt_publish = models.Edition.objects.get(name='publish')
    for data in [{'edition':edt_work,    'name':'initialized', 'info':u'初始化'},
                 {'edition':edt_work,    'name':'assigned',    'info':u'已分配'},
                 {'edition':edt_work,    'name':'submitted',   'info':u'已提交'},
                 {'edition':edt_publish, 'name':'approved',    'info':u'已通过'},
                 {'edition':edt_work,    'name':'unapproved',  'info':u'未通过'},
                 {'edition':edt_publish, 'name':'expired',     'info':u'已过期'},
                 {'edition':edt_publish, 'name':'ignored',     'info':u'已忽略'},
                 ]: models.Status(**data).save()
    
    #Task
    
    
    pass
