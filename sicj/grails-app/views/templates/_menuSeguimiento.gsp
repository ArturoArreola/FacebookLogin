<ul class="nav nav-tabs">
    <g:if test="${juicio?.estadoDeJuicio?.id != 7}">
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-gear"></i> Opciones
                <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <g:if test="${juicio?.estadoDeJuicio?.id != 6}">
                    <g:if test="${juicio?.estadoDeJuicio?.id != 4 && juicio?.estadoDeJuicio?.id != 2}">   
                        <li><g:link controller="juicio" action="edit" id="${juicio.id}"><i class="fa fa-edit"></i> Editar Asunto</g:link></li>
                            <li><a onclick="mostrarModal('modalEditarPreguntas');"><i class="fa fa-eraser"></i> Editar Flujo</a></li>
                        </g:if>
                        <g:if test="${juicio?.estadoDeJuicio?.id == 3}">
                        <li><a onclick="mostrarTerminarJuicio(${juicio.id},3);"><i class="fa fa-pause"></i> Pausar </a></li>
                        </g:if>
                    <sec:ifAnyGranted roles='ROLE_REACTIVAR_JUICIO_TERMINADO,ROLE_ADMIN'> 
                        <g:if test="${juicio?.estadoDeJuicio?.id == 2 || juicio?.estadoDeJuicio?.id == 4}">
                            <li><a onclick="mostrarTerminarJuicio(${juicio.id},1);"><i class="fa fa-play"></i> Reactivar </a></li>
                            </g:if>
                    </sec:ifAnyGranted> 
                    <g:if test="${juicio?.estadoDeJuicio?.id != 4}">
                        <sec:ifAnyGranted roles='ROLE_CANCELADO_POR_ERROR,ROLE_ADMIN'>
                            <li><a onclick="mostrarTerminarJuicio(${juicio.id},4);"><i class="fa fa-ban"></i> Cancelar por Error </a></li>
                        </sec:ifAnyGranted> 
                        <g:if test="${juicio?.estadoDeJuicio?.id != 2}">
                            <li><a onclick="mostrarTerminarJuicio(${juicio.id},2);"><i class="fa fa-stop"></i> Terminar </a></li>
                            </g:if>
                        <li><a onclick="mostrarModal('modalReactivarAsunto')"><i class="fa fa-retweet"></i> Reproceso </a></li>
                    <!--<li><a onclick="mostrarTerminarJuicio(${juicio.id},0);"><i class="fa fa-money"></i> Pagar Juicio </a></li>-->
                            <g:if test="${juicio?.estadoDeJuicio?.id != 2}">
                            <li><a onclick="mostrarModal('modalProcedimientoAlterno')"><i class="fa fa-arrow-circle-right"></i> Procedimiento Alterno </a></li>
                            </g:if>
                        </g:if>
                    <sec:ifAnyGranted roles='ROLE_PASAR_A_ARCHIVO_DEFINITIVO,ROLE_ADMIN'>
                        <g:if test="${juicio?.estadoDeJuicio?.id == 2}">
                            <li><g:link controller="juicio" action="cambiarEstadoJuicio" id="${juicio.id}" params="[estado: 6]"><i class="fa fa-archive"></i> Pasar a Archivo Definitivo </g:link></li>
                            </g:if>
                    </sec:ifAnyGranted> 
                </g:if>
                <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REACTIVAR_JUICIO_ARCHIVO_DEFINITIVO,ROLE_PASAR_A_HISTORICO'>  
                    <g:if test="${juicio?.estadoDeJuicio?.id == 6}">
                        <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REACTIVAR_JUICIO_ARCHIVO_DEFINITIVO'> 
                            <li><a onclick="mostrarTerminarJuicio(${juicio.id},1);"><i class="fa fa-play"></i> Reactivar </a></li>
                        </sec:ifAnyGranted>
                        <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_PASAR_A_HISTORICO'> 
                            <li><g:link controller="juicio" action="cambiarEstadoJuicio" id="${juicio.id}" params="[estado: 7]"><i class="fa fa-archive"></i> Pasar a Archivo Histórico </g:link></li>
                            </sec:ifAnyGranted>
                    </g:if>
                </sec:ifAnyGranted>
            </ul>
        </li>
    </g:if>
    <li><a onclick="obtenerHistorial(${juicio.id});"><i class="fa fa-arrow-circle-right"></i> Seguimiento del Juicio</a></li>
    <li><a onclick="$('#modalCalendario').modal('show');"><i class="fa fa-calendar"></i> Calendario de Audiencias</a></li>
    <li><a onclick="mostrarModal('modalArchivos');"><i class="fa fa-folder-open"></i> Archivo(s)</a></li>
    <li><a onclick="obtenerDatosMigrados(${juicio.id});"><i class="fa fa-paperclip"></i> Datos Adicionales</a></li>
    <li><a href="#"><i class="fa fa-comments"></i> Comentarios</a></li>
</ul>