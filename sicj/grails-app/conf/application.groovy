// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'mx.gox.infonavit.sicj.admin.Usuario'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'mx.gox.infonavit.sicj.admin.UsuarioRol'
grails.plugin.springsecurity.authority.className = 'mx.gox.infonavit.sicj.admin.Rol'
grails.plugin.springsecurity.authority.groupAuthorityNameField = 'authorities'
grails.plugin.springsecurity.useRoleGroups = true
grails.plugin.springsecurity.successHandler.alwaysUseDefault = true
grails.plugin.springsecurity.successHandler.alwaysUseDefaultTargetUrl = true
grails.plugin.springsecurity.successHandler.defaultTargetUrl = '/dashboard/index'
grails.plugin.springsecurity.adh.errorPage = '/denied' 

grails.plugin.springsecurity.controllerAnnotations.staticRules = [
    [pattern: '/',               access: ['permitAll']],
    [pattern: '/error',          access: ['permitAll']],
    [pattern: '/index',          access: ['permitAll']],
    [pattern: '/index.gsp',      access: ['permitAll']],
    [pattern: '/shutdown',       access: ['permitAll']],
    [pattern: '/skin-config',    access: ['permitAll']],
    [pattern: '/skin-config.gsp',access: ['permitAll']],
    [pattern: '/assets/**',      access: ['permitAll']],
    [pattern: '/**/js/**',       access: ['permitAll']],
    [pattern: '/**/css/**',      access: ['permitAll']],
    [pattern: '/**/img/**',      access: ['permitAll']],
    [pattern: '/**/fonts/**',    access: ['permitAll']],
    [pattern: '/**/images/**',   access: ['permitAll']],
    [pattern: '/**/favicon.ico', access: ['permitAll']],
    [pattern: '/dashboard/**',   access: ['isFullyAuthenticated()']],
    [pattern: '/proveedor/**',    access: ['ROLE_ADMIN','ROLE_REZAGO_HISTORICO','ROLE_REZAGO_HISTORICO_NACIONAL']],
    [pattern: '/despacho/**',    access: ['ROLE_ADMIN','ROLE_ALTA_LABORAL','ROLE_ALTA_CIVIL','ROLE_ALTA_PENAL','ROLE_ALTA_LABORAL_NACIONAL','ROLE_ALTA_CIVIL_NACIONAL','ROLE_ALTA_PENAL_NACIONAL', 'ROLE_LABORAL', 'ROLE_CIVIL', 'ROLE_PENAL']],
    [pattern: '/autoridad/**',   access: ['ROLE_ADMIN','ROLE_ALTA_LABORAL','ROLE_ALTA_CIVIL','ROLE_ALTA_PENAL','ROLE_ALTA_LABORAL_NACIONAL','ROLE_ALTA_CIVIL_NACIONAL','ROLE_ALTA_PENAL_NACIONAL', 'ROLE_LABORAL', 'ROLE_CIVIL', 'ROLE_PENAL']],
    [pattern: '/region/**',      access: ['ROLE_ADMIN','ROLE_ALTA_LABORAL','ROLE_ALTA_CIVIL','ROLE_ALTA_PENAL','ROLE_ALTA_LABORAL_NACIONAL','ROLE_ALTA_CIVIL_NACIONAL','ROLE_ALTA_PENAL_NACIONAL', 'ROLE_LABORAL', 'ROLE_CIVIL', 'ROLE_PENAL']],
    [pattern: '/persona/**',     access: ['ROLE_ADMIN','ROLE_ALTA_LABORAL','ROLE_ALTA_CIVIL','ROLE_ALTA_PENAL','ROLE_ALTA_LABORAL_NACIONAL','ROLE_ALTA_CIVIL_NACIONAL','ROLE_ALTA_PENAL_NACIONAL', 'ROLE_LABORAL', 'ROLE_CIVIL', 'ROLE_PENAL']],
    [pattern: '/delegacion/**',  access: ['ROLE_ADMIN','ROLE_ALTA_LABORAL','ROLE_ALTA_CIVIL','ROLE_ALTA_PENAL','ROLE_ALTA_LABORAL_NACIONAL','ROLE_ALTA_CIVIL_NACIONAL','ROLE_ALTA_PENAL_NACIONAL', 'ROLE_LABORAL', 'ROLE_CIVIL', 'ROLE_PENAL']],
    [pattern: '/juicio/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/user/**',        access: ['ROLE_ADMIN']],
    [pattern: '/role/**',        access: ['ROLE_ADMIN']],
    [pattern: '/usuario/**',     access: ['ROLE_ADMIN']],
    [pattern: '/rol/**',         access: ['ROLE_ADMIN']],
    [pattern: '/perfil/**',      access: ['ROLE_ADMIN']],
    [pattern: '/catalogos/**',   access: ['ROLE_ADMIN']],
    [pattern: '/division/**',   access: ['ROLE_ADMIN']],
    [pattern: '/delito/**',   access: ['ROLE_ADMIN']],
    [pattern: '/formaDePago/**',   access: ['ROLE_ADMIN']],
    [pattern: '/motivoDeTermino/**',   access: ['ROLE_ADMIN']],
    [pattern: '/patrocinadorDelJuicio/**',   access: ['ROLE_ADMIN']],
    [pattern: '/prestacionReclamada/**',   access: ['ROLE_ADMIN']],
    [pattern: '/tipoAsociado/**',   access: ['ROLE_ADMIN']],
    [pattern: '/tipoDeAsignacion/**',   access: ['ROLE_ADMIN']],
    [pattern: '/tipoDeAudiencia/**',   access: ['ROLE_ADMIN']],
    [pattern: '/tipoDeAutoridad/**',   access: ['ROLE_ADMIN']],
    [pattern: '/audienciaJuicio/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/aviso/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/persona/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/transferenciaJuicio/**',      access: ['ROLE_ADMIN']],
    [pattern: '/reportes/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/perfilDeUsuario/**',      access: ['isFullyAuthenticated()']],
    [pattern: '/monitoring', access: ['ROLE_ADMIN']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
    [pattern: '/assets/**',      filters: 'none'],
    [pattern: '/**/js/**',       filters: 'none'],
    [pattern: '/**/css/**',      filters: 'none'],
    [pattern: '/**/images/**',   filters: 'none'],
    [pattern: '/**/favicon.ico', filters: 'none'],
    [pattern: '/**',             filters: 'JOINED_FILTERS']
]

grails.assets.excludes = ["**/*.less"]