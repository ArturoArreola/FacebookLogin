<sec:ifLoggedIn>
    <li>
        <g:link controller="dashboard" action="index"><i class="fa fa-home"></i><span class="nav-label">Principal</span></g:link>
        </li>
        <sec:ifAnyGranted roles='ROLE_ADMIN'>   
            <li>
                <a href="#"><i class="fa fa-cogs"></i> <span class="nav-label">Administración</span> <span class="fa arrow"></span></a>
                <ul class="nav nav-second-level collapse">
                    <li>
                    <g:link controller="user" action="search">Usuarios</g:link>
                    </li>
                    <li>
                    <g:link controller="role" action="index">Roles</g:link>
                    </li>
                    <li>
                    <g:link controller="perfil" action="index">Perfiles</g:link>
                    </li>
                    <li>
                    <g:link controller="delegacion" action="index">Delegaciones</g:link>
                    </li>
                    <li>
                    <g:link controller="despacho" action="index">Despachos</g:link>
                    </li>
                    <li>
                    <g:link controller="proveedor" action="index">Proveedores</g:link>
                    </li>
                    <li>
                    <g:link controller="autoridad" action="index">Autoridades</g:link>
                    </li>
                    <li>
                    <g:link controller="catalogos" action="index">Catálogos</g:link>
                    </li>
                    <li>
                    <g:link controller="aviso" action="index">Avisos</g:link>
                    </li>
                    <li>
                    <g:link controller="persona" action="edit">Actores</g:link>
                    </li>
                </ul>
            </li>
        </sec:ifAnyGranted>
        <li>
            <a href="#"><i class="fa fa-gavel"></i> <span class="nav-label">Alta de Juicios</span> <span class="fa arrow"></span></a>
            <ul class="nav nav-second-level collapse">
                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_LABORAL,ROLE_ALTA_LABORAL,ROLE_ALTA_LABORAL_NACIONAL'> 
                    <li>
                    <g:link controller="juicio" action="create" params="[materia:'laboral']">Laboral</g:link>
                    </li>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CIVIL,ROLE_ALTA_CIVIL,ROLE_ALTA_CIVIL_NACIONAL'> 
                    <li>
                    <g:link controller="juicio" action="create" params="[materia:'civil']">Civil/Mercantil</g:link>
                    </li>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_PENAL,ROLE_ALTA_PENAL,ROLE_ALTA_PENAL_NACIONAL'> 
                    <li>
                    <g:link controller="juicio" action="create" params="[materia:'penal']">Penal</g:link>
                    </li>
                </sec:ifAnyGranted>
            </ul>
        </li>
        <li>
        <g:link controller="audienciaJuicio" action="index"><i class="fa fa-calendar"></i> <span class="nav-label">Calendario de Audiencias</span></g:link>
        </li>
        <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_LABORAL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_CIVIL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_PENAL_NACIONAL,ROLE_CONSULTA_ARCHIVO_DEFINITIVO_NACIONALROLE_CONSULTA_JUICIO_LABORAL,ROLE_CONSULTA_JUICIO_CIVIL,ROLE_CONSULTA_JUICIO_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL_LABORAL,ROLE_CONSULTA_JUICIO_NACIONAL_CIVIL,ROLE_CONSULTA_JUICIO_NACIONAL_PENAL,ROLE_CONSULTA_JUICIO_NACIONAL,ROLE_CONSULTA_HISTORICO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_PENAL_NACIONAL,ROLE_CONSULTA_HISTORICO_LABORAL,ROLE_CONSULTA_HISTORICO_CIVIL,ROLE_CONSULTA_HISTORICO_PENAL,ROLE_CONSULTA_HISTORICO_NACIONAL,ROLE_CONSULTA_AUDITOR'>
            <li>
            <g:link controller="juicio" action="search"><i class="fa fa-search"></i> <span class="nav-label">Búsqueda de Juicio</span></g:link>
            </li>
        </sec:ifAnyGranted>
        <sec:ifAnyGranted roles='ROLE_ADMIN'>
            <li>
            <g:link controller="juicio" action="reasignarJuicio"><i class="fa fa-recycle"></i> <span class="nav-label">Reasignacion de Juicios</span></g:link>
            </li>
            <li>
            <g:link controller="juicio" action="transferirJuicio"><i class="fa fa-archive"></i> <span class="nav-label">Transferencia de Juicios</span></g:link>
            </li>
        </sec:ifAnyGranted>
        <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REPORTE_POR_MATERIA,ROLE_REPORTE_POR_MATERIA_NACIONAL,ROLE_REPORTE_POR_MATERIA_NACIONAL_LABORAL,ROLE_REPORTE_POR_MATERIA_NACIONAL_CIVIL,ROLE_REPORTE_POR_MATERIA_NACIONAL_PENAL'>  
            <li>
            <g:link controller="reportes" action="index"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Reportes</span></g:link>
            </li>
        </sec:ifAnyGranted>
        <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CONSULTA_HISTORICO_LABORAL_NACIONAL,ROLE_CONSULTA_HISTORICO_CIVIL_NACIONAL,ROLE_CONSULTA_HISTORICO_PENAL_NACIONAL,ROLE_CONSULTA_HISTORICO_LABORAL,ROLE_CONSULTA_HISTORICO_CIVIL,ROLE_CONSULTA_HISTORICO_PENAL,ROLE_CONSULTA_HISTORICO_NACIONAL,ROLE_CONSULTA_AUDITOR'>
            <li>
            <g:link controller="juicio" action="archivoHistorico"><i class="fa fa-dropbox"></i> <span class="nav-label">Archivo Definitivo antes de 2014</span></g:link>
        </li>
    </sec:ifAnyGranted>
</sec:ifLoggedIn>