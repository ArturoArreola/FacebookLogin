<ul class="nav nav-tabs">
    <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-briefcase"></i> Registrar nuevo Asunto
            <span class="caret"></span></a>
        <ul class="dropdown-menu">
            <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_LABORAL,ROLE_ALTA_LABORAL,ROLE_ALTA_LABORAL_NACIONAL'> 
                <li><a href="/sicj/juicio/create?materia=laboral">Laboral</a></li>
            </sec:ifAnyGranted>
            <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_CIVIL,ROLE_ALTA_CIVIL,ROLE_ALTA_CIVIL_NACIONAL'> 
                <li><a href="/sicj/juicio/create?materia=civil">Civil/Mercantil</a></li>
            </sec:ifAnyGranted>
            <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_PENAL,ROLE_ALTA_PENAL,ROLE_ALTA_PENAL_NACIONAL'> 
                <li><a href="/sicj/juicio/create?materia=penal">Penal</a></li>
            </sec:ifAnyGranted>
        </ul>
    </li>
    <li><a href="/sicj/juicio/search"> <i class="fa fa-search"></i> Búsqueda y Seguimiento</a></li>
    <li><a href="/sicj/audienciaJuicio/index"><i class="fa fa-calendar"></i> Calendario de Audiencias</a></li>
    <sec:ifAnyGranted roles='ROLE_ADMIN'> 
        <li><a href="/sicj/juicio/transferirJuicio"><i class="fa fa-archive"></i> Transferencia de Juicios</a></li>
    </sec:ifAnyGranted>
</ul>