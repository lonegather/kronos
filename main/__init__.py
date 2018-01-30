# -*- coding: utf-8 -*-


def reset_data():
    from . import models
    
    tables = [
        models.Department, models.Role,
        models.Project, models.Edition, models.Genus, models.Tag,
        models.Entity, models.Stage, models.Status, models.Task
    ]
    
    for table in tables:
        for data in table.objects.all():
            data.delete()

    #Department
    for data in [
        {'name':'global',    'info':u'统筹'},
        {'name':'design',    'info':u'原画'},
        {'name':'modeling',  'info':u'模型'},
        {'name':'rigging',   'info':u'绑定'},
        {'name':'animation', 'info':u'动画'},
        {'name':'rendering', 'info':u'渲染'},
    ]: models.Department(**data).save()

    #Role
    for data in [
        {'name':'staff', 'info':u'制作人员'},
        {'name':'supervisor', 'info':u'组长'},
        {'name':'producer', 'info':u'制片'},
        {'name':'director', 'info':u'导演'},
        {'name':'administrator', 'info':u'管理员'},
    ]: models.Role(**data).save()
    
    #Project
    for data in [
        {'name':'|'                                                            },
        {'name':'PT | S02', 'info':u'哈喽葡星人 第二季', 'url':'file:///P:/PT/S02'},
        {'name':'MB | S01', 'info':u'百变布鲁可 第一季', 'url':'file:///P:/MB/S01'},
    ]: models.Project(**data).save()
    
    #Edition
    for data in [
        {'name':'work',    'url_head':'work',    'url_history':'history/work'   },
        {'name':'publish', 'url_head':'publish', 'url_history':'history/publish'},
    ]: models.Edition(**data).save()
    
    #Genus
    for data in [
        {'name':'asset', 'info':u'资产', 'url':'assets'},
        {'name':'shot',  'info':u'镜头', 'url':'shots' },
        {'name':'batch', 'info':u'批次', 'url':''      },
    ]: models.Genus(**data).save()
    
    #Tag
    prj_all = models.Project.objects.get(name='|')
    gns_batch = models.Genus.objects.get(name='batch')
    gns_asset = models.Genus.objects.get(name='asset')
    for data in [
        {'project':prj_all, 'genus':gns_batch, 'name':'scene',   'info':u'场次', 'url':''     },
        {'project':prj_all, 'genus':gns_batch, 'name':'episode', 'info':u'集数', 'url':''     },
        {'project':prj_all, 'genus':gns_asset, 'name':'CH',      'info':u'角色', 'url':'char' },
        {'project':prj_all, 'genus':gns_asset, 'name':'PR',      'info':u'道具', 'url':'prop' },
        {'project':prj_all, 'genus':gns_asset, 'name':'SC',      'info':u'场景', 'url':'scene'},
    ]: models.Tag(**data).save()
    
    #Stage
    prj_pt02 = models.Project.objects.get(name='PT | S02')
    prj_mb01 = models.Project.objects.get(name='MB | S01')
    gns_shot = models.Genus.objects.get(name='shot')
    for prj in [prj_pt02, prj_mb01]:
        for data in [
            {'project':prj, 'genus':gns_batch, 'name':'script',      'info':u'剧本', 'path':'{project}/{stage}/{entity}',                         'url':'scp'},
            {'project':prj, 'genus':gns_batch, 'name':'storyboard',  'info':u'分镜', 'path':'{project}/{stage}/{entity}',                         'url':'stb'},
            {'project':prj, 'genus':gns_batch, 'name':'dubbing',     'info':u'配音', 'path':'{project}/{stage}/{entity}',                         'url':'dub'},
            {'project':prj, 'genus':gns_asset, 'name':'design',      'info':u'原画', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'dsn'},
            {'project':prj, 'genus':gns_asset, 'name':'modeling',    'info':u'建模', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'mdl'},
            {'project':prj, 'genus':gns_asset, 'name':'texture',     'info':u'贴图', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'txt'},
            {'project':prj, 'genus':gns_asset, 'name':'shader',      'info':u'材质', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'shd'},
            {'project':prj, 'genus':gns_asset, 'name':'rigging',     'info':u'绑定', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'rig'},
            {'project':prj, 'genus':gns_asset, 'name':'preview',     'info':u'预览', 'path':'{project}/{edition}/{genus}/{tag}/{entity}/{stage}', 'url':'prv'},
            {'project':prj, 'genus':gns_shot,  'name':'layout',      'info':u'布局', 'path':'{project}/{edition}/{genus}/{stage}/{tag}',          'url':'lyt'},
            {'project':prj, 'genus':gns_shot,  'name':'animation',   'info':u'动画', 'path':'{project}/{edition}/{genus}/{stage}/{tag}',          'url':'anm'},
            {'project':prj, 'genus':gns_shot,  'name':'cfx',         'info':u'解算', 'path':'{project}/{edition}/{genus}/{stage}/{tag}',          'url':'cfx'},
            {'project':prj, 'genus':gns_shot,  'name':'lighting',    'info':u'灯光', 'path':'{project}/{edition}/{genus}/{stage}/{tag}',          'url':'lgt'},
            {'project':prj, 'genus':gns_shot,  'name':'rendering',   'info':u'渲染', 'path':'{project}/{edition}/{genus}/{stage}/{tag}/{entity}', 'url':'rnd'},
            {'project':prj, 'genus':gns_shot,  'name':'vfx',         'info':u'特效', 'path':'{project}/{edition}/{genus}/{stage}/{tag}/{entity}', 'url':'vfx'},
            {'project':prj, 'genus':gns_shot,  'name':'compositing', 'info':u'合成', 'path':'{project}/{edition}/{genus}/{stage}/{tag}/{entity}', 'url':'cmp'},
        ]: models.Stage(**data).save()

    # Entity
    tag_eps = models.Tag.objects.get(name='episode')
    tag_ch  = models.Tag.objects.get(name='CH')
    for data in [
        {'project':prj_mb01, 'tag':tag_eps, 'name':'EP01',  'url':'EP01' },
        {'project':prj_pt02, 'tag':tag_eps, 'name':'EP01',  'url':'EP01' },
        {'project':prj_mb01, 'tag':tag_ch,  'name':'Danny', 'url':'Danny'},
        {'project':prj_pt02, 'tag':tag_ch,  'name':'Houye', 'url':'Houye'},
    ]: models.Entity(**data).save()
    
    #Status
    edt_work = models.Edition.objects.get(name='work')
    edt_publish = models.Edition.objects.get(name='publish')
    for data in [
        {'edition':edt_work,    'name':'initialized', 'info':u'初始化'},
        {'edition':edt_work,    'name':'assigned',    'info':u'已分配'},
        {'edition':edt_work,    'name':'submitted',   'info':u'已提交'},
        {'edition':edt_publish, 'name':'approved',    'info':u'已通过'},
        {'edition':edt_work,    'name':'unapproved',  'info':u'未通过'},
        {'edition':edt_publish, 'name':'expired',     'info':u'已过期'},
        {'edition':edt_publish, 'name':'ignored',     'info':u'已忽略'},
    ]: models.Status(**data).save()
    
    #Task
    
    
    pass
