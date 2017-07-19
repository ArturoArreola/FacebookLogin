class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/"(controller: 'dashboard', action: 'index')
        "/sking-config.gsp"(view:'/skin-config')
        "500"(view:'/error')
        "404"(view:'/notFound')
        "403"(view:'/denied')
    }
}
