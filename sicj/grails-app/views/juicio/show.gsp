<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <!-- DROPZONE -->
        <g:external dir="assets/plugins/dropzone" file="basic.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.js" />
        <!-- Clock picker -->
        <g:external dir="assets/plugins/clockpicker" file="clockpicker.css" />
        <g:external dir="assets/plugins/clockpicker" file="clockpicker.js" />
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
        <!-- html2canvas -->
        <g:external dir="assets/plugins/html2canvas" file="html2canvas.js" />
        <!-- jsPDF -->
        <g:external dir="assets/plugins/jsPDF" file="jspdf.min.js" />
        <g:external dir="assets/plugins/jsPDF/plugins" file="addimage.js" />
        <!-- Moment -->
        <g:external dir="assets/plugins/moment" file="moment.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Control de Juicios</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/juicio/search">Juicios</a>
                    </li>
                    <li class="active">
                        <strong>Seguimiento de Asunto </strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:if test="${juicio && juicio != null}">
                <g:render template="/templates/menuSeguimiento"/>
                <div id="datosGeneralesDelJuicio" class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5><span class="label label-info">${juicio?.materia}</span><span>&nbsp;&nbsp;&nbsp;Seguimiento del Juicio ${juicio?.expedienteInterno}<g:if test="${procesoAlterno?.estadoDeProceso?.id == 1}"><label style="float: right;" class="label label-warning">EN PROCESO ALTERNO</label></g:if><g:if test="${juicio?.tipoDeReproceso}"><label style="float: right;" class="label label-danger">REPROCESO POR ${juicio?.tipoDeReproceso?.nombre}</label></g:if></span></h5>
                                    <div class="ibox-tools">
                                        <a class="btn btn-xs btn-primary" onclick="exportarSeguimiento();"><i class="fa fa-file-pdf-o"></i> Exportar a PDF</a>
                                        <sec:ifAnyGranted roles='ROLE_ALTA_CIVIL,ROLE_ALTA_CIVIL_NACIONAL,ROLE_ALTA_LABORAL,ROLE_ALTA_LABORAL_NACIONAL,ROLE_ALTA_PENAL,ROLE_ALTA_PENAL_NACIONAL,ROLE_REZAGO_HISTORICO, ROLE_REZAGO_HISTORICO_NACIONAL'>
                                            <g:link class="btn btn-xs btn-warning" style="color: #ffffff;" action="create" params="[materia: juicio?.materia?.nombreCarpeta]">Regresar a creación de Juicios</g:link>
                                        </sec:ifAnyGranted> 
                                        <a class="collapse-link">
                                            <i class="fa fa-chevron-up"></i>
                                        </a>
                                    </div>
                                </div>
                                <div class="ibox-content">
                                <g:if test="${flash.message}">
                                    <center>
                                        <div class="alert alert-info alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            ${flash.message}
                                        </div>
                                    </center>
                                </g:if>
                                <g:if test="${flash.error}">
                                    <center>
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            ${flash.error}
                                        </div>
                                    </center>
                                </g:if> 
                                <h4>Etapa Procesal</h4>
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <%
def etapaId = juicio.ultimaPregunta ?  juicio.ultimaPregunta?.etapaProcesal?.id : -1 as long 
%>
                                        <g:each var='etapaProcesal' in='${etapasProcesales}'>
                                            <% def color = colores.find { it.find { key, value -> (key == 'etapaProcesal' && value == etapaProcesal?.etapaProcesal?.id) } }%>
                                            <g:if test="${juicio.estadoDeJuicio.id == 1 && ((juicio.ultimaPregunta?.etapaProcesal?.id == etapaProcesal.etapaProcesal.id) || (juicio.etapaProcesal == null && etapaProcesal.numeroSecuencial == 1) || (juicio.etapaProcesal && juicio.ultimaPregunta == null))}">
                                                <a onclick="obtenerSiguientePregunta(${juicio.id});">
                                                </g:if>
                                                <span class="badge ${color?.color}">${etapaProcesal.numeroSecuencial} - ${etapaProcesal.etapaProcesal.nombre}</span>
                                                <g:if test="${juicio.estadoDeJuicio.id == 1 && ((juicio.ultimaPregunta?.etapaProcesal?.id == etapaProcesal.etapaProcesal.id) || (juicio.etapaProcesal == null && etapaProcesal.numeroSecuencial == 1) || (juicio.etapaProcesal && juicio.ultimaPregunta == null))}">
                                                </a>
                                            </g:if>&nbsp;
                                        </g:each>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <g:render template="/templates/datosSeguimiento" />
                                </div>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5> Procesos Alternos </h5>
                                <div class="ibox-tools">
                                    <a class="collapse-link">
                                        <i class="fa fa-chevron-up"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <g:if test="${procesosAlternos}">
                                    <table style="width:100%;font-size: 12px" id="acuerdosJuicio" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th style="text-align: center;">Tipo de Proceso</th>
                                                <th style="text-align: center;">Estado del Proceso</th>
                                                <th style="text-align: center;">Autoridad Judicial</th>
                                                <th style="text-align: center;">Expediente</th>
                                                <th style="text-align: center;">Observaciones</th>
                                                <th style="text-align: center;">Notas Finales</th>
                                                <th style="text-align: center;">Creación/Termino</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each var='procesoAlterno' in='${procesosAlternos}'>
                                                <tr>
                                                    <td style="text-align: center;">${procesoAlterno.tipoDeProcesoAlterno}</td>
                                                    <td style="text-align: center;">${procesoAlterno.estadoDeProceso}</td>
                                                    <td style="text-align: center;">${procesoAlterno.autoridadJudicial}</td>
                                                    <td style="text-align: center;">${procesoAlterno.expediente}</td>
                                                    <td style="text-align: justify;">${procesoAlterno.observaciones}</td>
                                                    <td style="text-align: justify;">${procesoAlterno.notasFinales}</td>
                                                    <td style="text-align: left;">
                                                        <small><b>Creado Por:</b><br/>${procesoAlterno.usuarioQueRegistro}</small><br />
                                                        <small><b>Fecha de Registro:</b><br/><g:formatDate format="dd/MM/yyyy" date="${procesoAlterno.fechaDeRegistro}" /></small>
                                                            <g:if test="${procesoAlterno.estadoDeProceso.id == 2}">
                                                            <br/><small><b>Terminado Por:</b><br/>${procesoAlterno.usuarioQueTermino}</small><br />
                                                            <small><b>Fecha de Termino:</b><br/><g:formatDate format="dd/MM/yyyy" date="${procesoAlterno.fechaDeTermino}" /></small>
                                                            </g:if>
                                                    </td>
                                                </tr>
                                            </g:each>    
                                        </tbody>
                                    </table>
                                </g:if>
                                <g:else>
                                    No se han registrado procesos alternos para este asunto.
                                </g:else>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5> Acuerdos </h5>
                                <div class="ibox-tools">
                                    <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                                        <button class="btn btn-primary btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Acuerdo" onclick="$('#modalAltaAcuerdo').modal('show')"><i class="fa fa-plus"></i></button>
                                        </g:if>
                                    <a class="collapse-link">
                                        <i class="fa fa-chevron-up"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <g:if test="${acuerdos}">
                                    <table style="width:100%;" id="acuerdosJuicio" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th style="width: 10%; text-align: center;">Fecha de Alta del Acuerdo</th>
                                                <th style="width: 10%; text-align: center;">Registrado Por</th>
                                                <th style="width: 10%; text-align: center;">Fecha de Publicación o Notificación</th>
                                                <th style="width: 50%;text-align: center;">Observaciones</th>
                                                <th style="width: 20%;text-align: center;">Archivo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each var='acuerdo' in='${acuerdos}'>
                                                <tr>
                                                    <td style="width: 10%; text-align: center;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${acuerdo.fechaDeRegistro}" /></td>
                                                    <td style="width: 10%; text-align: center;">${acuerdo.usuarioQueRegistro}</td>
                                                    <td style="width: 10%; text-align: center;"><g:formatDate format="dd/MM/yyyy" date="${acuerdo.fechaDePublicacion}" /></td>
                                                    <td style="width: 50%; text-align: justify;">${acuerdo.observaciones}</td>
                                                    <td style="width: 20%; text-align: center;"><g:link class="btn btn-primary btn-xs" action="descargarArchivo" id="${acuerdo.rutaArchivo}">Descargar Anexo</g:link></td>
                                                    </tr>
                                            </g:each>    
                                        </tbody>
                                    </table>
                                </g:if>
                                <g:else>
                                    No se han registrado acuerdos para este asunto.
                                </g:else>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5> Promociones </h5>
                                <div class="ibox-tools">
                                    <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                                        <button class="btn btn-success btn-xs" type="button" data-toggle="tooltip" data-placement="top" title="Agregar Promoción" onclick="$('#modalAltaPromocion').modal('show')"><i class="fa fa-plus"></i></button>
                                        </g:if>
                                    <a class="collapse-link">
                                        <i class="fa fa-chevron-up"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <g:if test="${promociones}">
                                    <table style="width:100%;" id="acuerdosJuicio" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th style="width: 10%; text-align: center;">Fecha de Alta de la Promoción</th>
                                                <th style="width: 10%; text-align: center;">Registrada Por</th>
                                                <th style="width: 15%; text-align: center;">Promoción</th>
                                                <th style="width: 10%; text-align: center;">Fecha de Presentación</th>
                                                    <g:if test="${juicio.materia.id == 3}">
                                                    <th style="width: 10%;text-align: center;">Fecha de Promoción</th>
                                                    <th style="width: 25%;text-align: center;">Resumen de la Promoción</th>
                                                    </g:if>
                                                    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2}">
                                                    <th style="width: 35%; text-align: center;">Observaciones</th>
                                                    </g:if>
                                                <th style="width: 20%;text-align: center;">Archivo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each var='promocion' in='${promociones}'>
                                                <tr>
                                                    <td style="width: 10%;  text-align: center;"><g:formatDate format="dd/MM/yyyy HH:mm" date="${promocion.fechaDeRegistro}" /></td>
                                                    <td style="width: 10%;  text-align: center;">${promocion.usuarioQueRegistro}</td>
                                                    <td style="width: 15%;  text-align: center;">${promocion.tipoDeParte}</td>
                                                    <td style="width: 10%;  text-align: center;"><g:formatDate format="dd/MM/yyyy" date="${promocion.fechaDePresentacion}" /></td>
                                                    <g:if test="${juicio.materia.id == 3}">
                                                        <td style="width: 10%;  text-align: center;"><g:formatDate format="dd/MM/yyyy" date="${promocion.fechaDePromocion}" /></td>
                                                        <td style="width: 25%;  text-align: justify;"><p style="word-wrap: break-word;">${promocion.resumenDeLaPromocion}</p></td>
                                                        </g:if>
                                                        <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2}">
                                                        <td style="width: 35%;  text-align: justify;"><p style="word-wrap: break-word;">${promocion.observaciones}</p></td>
                                                        </g:if>
                                                    <td style="width: 20%; text-align: center;"><g:link class="btn btn-success btn-xs" action="descargarArchivo" id="${promocion.rutaArchivo}">Descargar Anexo</g:link></td>
                                                    </tr>
                                            </g:each> 
                                        </tbody>
                                    </table>
                                </g:if>
                                <g:else>
                                    No se han registrado promociones para este asunto.
                                </g:else>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalWorkFlow" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">WorkFlow - ${juicio.tipoDeProcedimiento}</h5>
                            </div>
                            <div class="modal-body" class="col-md-12" style="overflow-y: auto; max-height: calc(100vh - 210px);">
                                <div id="divPreguntas"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal" onclick="window.location.reload()">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalHistorial" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Seguimiento del Juicio</h5>
                                <h5 class="modal-title">${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divHistorial"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <g:if test="${juicio.estadoDeJuicio.id != 2 && juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
                    <div class="modal inmodal fade" id="modalCalendario" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                    <h5 class="modal-title">Calendario de Audiencias</h5>
                                    <h5 class="modal-title">Juicio ${juicio.expedienteInterno}</h5>
                                </div>
                                <div class="modal-body">
                                    <div clas="row">
                                        <center>
                                            <span class="badge" style="background: #f8ac59; color: #ffffff;">Activas</span>&nbsp;&nbsp;<span class="badge" style="background: #1ab394; color: #ffffff;">Atendidas</span>&nbsp;&nbsp;<span class="badge" style="background: #337ab7; color: #ffffff;">Diferidas</span>&nbsp;&nbsp;<span class="badge" style="background: #6E6E6E; color: #ffffff;">Canceladas</span>
                                        </center>
                                    </div>
                                    <g:render template="/templates/calendarioDeAudiencias"/>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:if>
                <div class="modal inmodal fade" id="modalTerminar" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Terminar Juicio ${juicio.expedienteInterno}</h5>
                                <h5 class="modal-title">¿Está seguro de finalizar el juicio?</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divTerminarJuicio"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalRegistrarNota" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Agregar Nota al Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <g:render template="/templates/registrarNota"/>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalNotas" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Notas del Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divNotasDelJuicio"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalArchivos" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-lg" style="width: 980px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Archivos del Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divArchivosDelJuicio">
                                    <g:render template="/templates/archivosDelJuicio"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalAltaAudiencia" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 400px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Alta de Audiencia<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="altaAudienciaDelJuicio" class="row">
                                    <g:render template="/templates/altaAudiencia"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalAltaAudienciaWF" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 400px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Alta de Audiencia<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="altaAudienciaDelJuicio" class="row">
                                    <g:render template="/templates/altaAudienciaWF"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalDetalleAudiencia" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 500px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Detalle de Audiencia<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divDetalleAudiencia" class="row">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalCambiarProvision" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Cambiar Provisión del Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <g:if test="${juicio}">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="ibox float-e-margins">
                                                <div class="ibox-content">
                                                    <g:form action="cambiarProvisionJuicio" class="form-horizontal">
                                                        <input type="hidden" name="id" id="provisionJuicioId" value="${juicio.id}"/>
                                                        <div class="form-group">
                                                            <label class="col-sm-3 control-label">Provisión: </label>
                                                            <div class="col-sm-9">
                                                                <div class="input-group">
                                                                    <g:select noSelection="['':'Elija la Provisión...']" data-placeholder="Elija la Provisión..." class="chosen-select" style="width:300px;" tabindex="2" name="provision.id" id="provision" from="${mx.gox.infonavit.sicj.catalogos.Provision?.list(sort: 'nombre')}" value="${juicio?.provision?.id}" optionKey="id"/>    
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="hr-line-dashed"></div>
                                                        <div class="form-group">
                                                            <div class="col-sm-4 col-sm-offset-2">
                                                                <button class="btn btn-primary" type="submit">Guardar</button>
                                                            </div>
                                                        </div>
                                                    </g:form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </g:if>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalAltaAcuerdo" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 400px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Alta de Acuerdo<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="altaAudienciaDelJuicio" class="row">
                                    <g:render template="/templates/altaAcuerdo"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalAltaPromocion" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 400px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Alta de Promocion<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="altaAudienciaDelJuicio" class="row">
                                    <g:render template="/templates/altaPromocion"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalReactivarAsunto" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Reproceso <br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <g:render template="/templates/reactivarAsunto"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalProcedimientoAlterno" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 400px;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Procedimiento Alterno<br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <g:form action="gestionDeAmparo"  enctype="multipart/form-data" useToken="true">
                                        <input type="hidden" name="amparoJuicioId" id="amparoJuicioId" value="${juicio.id}"/>
                                        <g:if test="${procesoAlterno?.estadoDeProceso?.id == 1}">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Notas </label>
                                                        <div class="input-group">
                                                            <textarea rows="4" cols="80" style="width: 300px;" id="notasFinales" name='notasFinales' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group text-center">
                                                        <input type="hidden" name="terminarAmparo" value="true" />
                                                        <button type="submit" class="btn btn-primary">Terminar Procedimiento Alterno</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </g:if>
                                        <g:else>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Tipo de Proceso *</label>
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija el Tipo de Proceso...']" required data-placeholder="Elija el Tipo de Proceso..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeProcesoAlterno.id" id="tipoDeProcesoAlterno" from="${mx.gox.infonavit.sicj.catalogos.TipoDeProcesoAlterno.list(sort: 'nombre')}" optionKey="id" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Autoridad Judicial *</label>
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija la Autoridad...']" required data-placeholder="Elija la Autoridad..." class="chosen-select" style="width:300px;" tabindex="2" name="autoridadJudicial.id" id="autoridadJudicial" from="${autoridadesProcesoAlterno}" optionKey="id" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Expediente *</label>
                                                        <div class="input-group">
                                                            <input id="expedienteProcesoAlterno" name="expedienteProcesoAlterno" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio.expedienteInterno}">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Observaciones y/o Nombre de la Autoridad </label>
                                                        <div class="input-group">
                                                            <textarea rows="4" cols="80" style="width: 300px;" id="observacionesProceso" name='observacionesProceso' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <label>Archivo</label>
                                                        <div class="input-group">
                                                            <input style="width: 300px;" name="archivoProcesoAlterno" id="archivoProcesoAlterno" type="file" class="form-control" accept=".pdf">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group text-center">
                                                        <input type="hidden" name="iniciarAmparo" value="true" />
                                                        <button type="submit" class="btn btn-primary">Iniciar Proceso Alterno</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </g:else>
                                    </g:form>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalBitacora" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Bitácora del Juicio</h5>
                                <h5 class="modal-title">${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divBitacora"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalEditarPreguntas" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Editar Respuestas <br />Juicio ${juicio.expedienteInterno}</h5>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <g:render template="/templates/editarFlujo"/>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalLista" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 40%;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Lista Completa</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divListaDePersonas"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal inmodal fade" id="modalDatosAdicionales" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" style="width: 80%;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                <h5 class="modal-title">Datos Adicionales<br/>(Migración de respuestas de WorkFlow)</h5>
                            </div>
                            <div class="modal-body">
                                <div id="divDatosMigrados"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <g:if test="${juicio.materia.id == 4}">
                    <div class="modal inmodal fade" id="modalRegistrarPago" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                    <h5 class="modal-title">Registrar Pago <br />Juicio ${juicio.expedienteInterno}</h5>
                                </div>
                                <div class="modal-body">
                                    <g:render template="/templates/registrarPago" />
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal inmodal fade" id="modalListaPagosRezago" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                    <h5 class="modal-title">Lista de Pagos <br />Juicio ${juicio.expedienteInterno}</h5>
                                </div>
                                <div class="modal-body">
                                    <div id="divPagosRezago">
                                        <g:render template="/templates/listaPagosRezago" />
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:if>
            </g:if>
            <g:else>
                <div class="row">
                    <center>
                        <div class="alert alert-danger">
                            No se ha especificado el juicio a consultar. Regrese a la página anterior o realice nuevamente la consulta del asunto.
                        </div>
                    </center>
                </div>
            </g:else>
        </div>
        <style>
            body.modal-open .datepicker {
            z-index: 100000 !important;
            }

            .popover.clockpicker-popover{
            z-index: 999999 !important;
            }
        </style>
        <script type="text/javascript">

            function exportarSeguimiento(){
            console.log("Si entra a exportarSeguimiento: " + $('#datosGeneralesDelJuicio').width() + "," + $('#datosGeneralesDelJuicio').height());
            var divHeight = $('#datosGeneralesDelJuicio').height();
            var divWidth = $('#datosGeneralesDelJuicio').width();
            var ratio = divHeight / divWidth;
            html2canvas(document.getElementById("datosGeneralesDelJuicio"), {
            onrendered: function(canvas) {
            var image = canvas.toDataURL("image/png");
            var doc = new jsPDF('l','pt', [$('#datosGeneralesDelJuicio').width(),$('#datosGeneralesDelJuicio').height()]);
            var width = (divWidth * .95);    
            var height = (divHeight * .95);
            doc.addImage(image, 'PNG', 0, 0, width, height);
            doc.save('seguimiento.pdf'); 
            }
            });
            }

            function obtenerDatosMigrados(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerDatosMigrados',
            success:function(data,textStatus){
            $('#divDatosMigrados').html(data);
            mostrarModal('modalDatosAdicionales');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });            
            }

            function obtenerSiguientePregunta(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerSiguientePregunta',
            success:function(data,textStatus){
            $('#divPreguntas').html(data);
            mostrarModal('modalWorkFlow');
            inicializarControles();
            validacionPreguntasWorkflow();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }
            
            function activarButon(valor) {
            if(valor != null){
            console.log("valor: " + valor);
            var partirFecha = valor.split('/');
            var fechaOrdenada = new Date(partirFecha[2],partirFecha[1]-1,partirFecha[0]); 
            console.log("fecha ordenada: " + fechaOrdenada);
            document.getElementsByName("registrarAudienciaWF")[0].disabled = false;
            document.getElementsByName("botonGuardar")[0].disabled = true;
            $('#mensajeAudienciaWorkFlow').show('slow');
            $('#registraAudienciaWorkFlow').show('slow');
            $('#modalAltaAudienciaWF #divFechaAudiencia').datepicker('setUTCDate', new Date(fechaOrdenada));
            $('.clockpicker').clockpicker({
            autoclose: true
            });
            } 
            }

            function mostrarModal(modal){
            $('#'+modal).modal('show');
            }

            function ocultarModal(modal){
            $('#'+modal).modal('hide');
            }

            function mostrarDatosPago(){
            $('#datosPago').show('slow');
            }

            function ocultarDatosPago(){
            $('#datosPago').hide('slow');
            }

            function mostrarListaCompleta(idJuicio, lista){
            jQuery.ajax({
            type:'POST',
            data:'idJuicio=' + idJuicio + "&lista=" + lista + "&editar=true",
            url:'/sicj/juicio/mostrarListaCompleta',
            success:function(data,textStatus){
            $('#divListaDePersonas').html(data);
            $('#modalLista').modal('show');
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            }
            });
            }

            function marcarDesistimiento(idPersona, idJuicio){
            jQuery.ajax({
            type:'POST',
            data:'idJuicio=' + idJuicio + "&idPersona=" + idPersona,
            url:'/sicj/juicio/marcarDesistimiento',
            success:function(data,textStatus){
            var respuesta = eval(data);
            if(respuesta.exito){
            ocultarModal('modalLista');
            swal("!Acción Ejecutada Correctamente!", "Se ha marcado al actor indicado como desistido de manera correcta.", "success");
            } else {
            swal("!Algo fallo!", respuesta.mensaje, "error");
            }
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            }
            });
            }

            function inicializarControles(){
            $('#fechaWorkFlow').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            calendarWeeks: true,
            daysOfWeekDisabled: [0,6],
            autoclose: true
            });
            $('#respuestaSelect').chosen({
            width: "365px"
            });
            var archivoDropzone = document.getElementById("divDropzoneWF");
            if(archivoDropzone){
            inicializarDropzone();
            }
            }

            function obtenerHistorial(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerHistorialDelJuicio',
            success:function(data,textStatus){
            $('#divHistorial').html(data);
            mostrarModal('modalHistorial');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function obtenerBitacora(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerBitacoraDelJuicio',
            success:function(data,textStatus){
            $('#divBitacora').html(data);
            mostrarModal('modalBitacora');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function obtenerNotas(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerNotasDelJuicio',
            success:function(data,textStatus){
            $('#divNotasDelJuicio').html(data);
            mostrarModal('modalNotas');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function inicializarDropzone(){
            var previewNode = document.querySelector("#templateWF");
            previewNode.id = "";
            var previewTemplate = previewNode.parentNode.innerHTML;
            previewNode.parentNode.removeChild(previewNode);

            Dropzone.autoDiscover = false;
            var workflowDropzone = new Dropzone('div#divDropzoneWF', {
            url: "/sicj/juicio/subirArchivo",
            uploadMultiple: true,
            parallelUploads: 1,
            paramName: "archivo",
            params: { 'archivoJuicioId': ${juicio?.id} },
            maxFiles: 1,
            maxFilesize: 20,
            acceptedFiles: ".pdf, .png, .jpg, application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, .csv, .xls, .xlsx",
            previewTemplate: previewTemplate,
            autoQueue: false,
            previewsContainer: "#previewsWF",
            clickable: "#actionsWF .fileinput-button"
            });
            workflowDropzone.on("totaluploadprogress", function(progress) {
            document.querySelector("#total-progressWF .progress-bar").style.width = progress + "%";
            $('#total-progress .progress-bar').html("" + progress + " %");
            });
            workflowDropzone.on("uploadprogress", function(file) {
            console.log(file.upload.progress);
            var progress = file.upload.progress;
            document.querySelector(".progress-bar-primary").style.width = progress + "%";
            $('.progress-bar-primary').html("" + progress + " %");
            });
            workflowDropzone.on("successmultiple", function(file, response) {
            var respuesta = eval(response);
            var auxiliar = $('#auxiliar').val();
            if(respuesta.idArchivo){
            $('#previewsWF .delete').hide();
            if(auxiliar === 'SI'){
            $('#datoAuxiliar').val(respuesta.idArchivo);
            } else {
            $('#valorRespuesta').val(respuesta.idArchivo);
            }
            }
            });
            workflowDropzone.on("sending", function(file) {
            document.querySelector("#total-progressWF").style.opacity = "1";
            });
            workflowDropzone.on("queuecomplete", function(progress) {
            $('#mensajesDropzoneWF').html("<center><div class='alert alert-info'>Los archivos se han cargado correctamente.</div></center>");
            });
            document.querySelector("#actionsWF .start").onclick = function(e) {
            e.preventDefault();
            e.stopPropagation();
            workflowDropzone.enqueueFiles(workflowDropzone.getFilesWithStatus(Dropzone.ADDED)); 
            };
            }

            function mostrarArchivos(juicio){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio,
            url:'/sicj/juicio/obtenerArchivosDelJuicio',
            success:function(data,textStatus){
            $('#divLista').html(data);
            $('#divSubirArchivo').hide('slow');
            $('#divLista').show('slow');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function mostrarAreaUpload(){
            $('#divSubirArchivo').show('slow');
            $('#divLista').hide('slow');
            }

            function mostrarAudiencia(data){
            var resultado = (data);
            if(resultado.error){
            var html = "<center><div class='alert alert-danger alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + data.error + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else if(resultado.mensaje){
            var html = "<center><div class='alert alert-info alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + resultado.mensaje + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else{
            console.log("ESTE ES EL RESULTADO: " + resultado);
            $("#calendar").fullCalendar('renderEvent', eval(data) ,true);
            $("#modalAltaAudiencia").modal('hide');
            }
            }

            function mostrarAudienciaWF(data){
            var resultado = (data);
            if(resultado.error){
            var html = "<center><div class='alert alert-danger alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + data.error + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else if(resultado.mensaje){
            var html = "<center><div class='alert alert-info alert-dismissable'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button>" + resultado.mensaje + "</div></center>";
            $('#mensajesAudiencia').html(html);
            } else{
            console.log("ESTE ES EL RESULTADO WF: " + resultado);
            $("#modalAltaAudienciaWF").modal('hide');
            document.getElementsByName("registrarAudienciaWF")[0].disabled = true;
            document.getElementsByName("botonGuardar")[0].disabled = false;
            }
            }
            
            function mostrarDetallesAudiencia(idAudiencia){
            jQuery.ajax({
            type:'POST',
            data:'audienciaId=' + idAudiencia,
            url:'/sicj/audienciaJuicio/obtenerDetallesAudiencia',
            success:function(data,textStatus){
            $('#divDetalleAudiencia').html(data);
            validacionAudienciaEditada();
            mostrarModal('modalDetalleAudiencia');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function editarAudiencia(){
            $('#verAudiencia').hide('slow');
            $('#btnDetalles').hide('slow');
            $('#editarAudiencia').show('slow');
            $('#hora').clockpicker({
            autoclose: true
            });
            $('#divFechaAud').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            calendarWeeks: true,
            daysOfWeekDisabled: [0,6],
            autoclose: true
            });
            }

            function cancelarAudiencia(audienciaId){
            jQuery.ajax({
            type:'POST',
            data:'audienciaId=' + audienciaId,
            url:'/sicj/audienciaJuicio/cancelar',
            success:function(data,textStatus){
            var resultado = eval(data);
            repintarAudiencia(resultado.id,'#676a6c');
            ocultarModal('modalDetalleAudiencia');
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            alert('algo fallo');
            }
            });
            return false
            }

            function repintarAudiencia(idAudiencia, color){
            var eventos = $("#calendar").fullCalendar( 'clientEvents', idAudiencia)
            for (var x = 0; x < eventos.length; x++) {
            eventos[x].color = color;
            $("#calendar").fullCalendar( 'updateEvent', eventos[x]);
            }
            }

            function mostrarOcultarMotivo(){
            if($('input[name=diferirAudiencia]').is(':checked')){
            $('#reprogramacion').show('slow');
            } else {
            $('#reprogramacion').hide('slow');
            }
            }

            function mostrarTerminarJuicio(juicio,estado){
            jQuery.ajax({
            type:'POST',
            data:'juicio=' + juicio + '&estado=' + estado,
            url:'/sicj/juicio/mostrarTerminarJuicio',
            success:function(data,textStatus){
            $('#divTerminarJuicio').html(data);
            if(estado != 0) {
            ocultarDatosPago();
            }
            mostrarModal('modalTerminar');
            $('#divfechaDeTermino').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            calendarWeeks: true,
            daysOfWeekDisabled: [0,6],
            autoclose: true
            });
            $('#motivoDeTermino').chosen({
            width: "365px"
            });
            $('#formaDePago').chosen({
            width: "365px"
            });
            validacionCambiarEstado();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
            html += "<option value=''>Elija una opción...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].textoPregunta + "</option>";
            }
            $('#'+tipo).html(html);
            redimensionarChosen('divPreguntasReactivar');
            $('#'+tipo).trigger("chosen:updated");
            }

            function redimensionarChosen(idDiv){
            $('#'+idDiv+" .chosen-container").css('width', '550px');
            //$('#'+idDiv+" .chosen-container").css('font-size', '11px');
            }

            function registrarAudiencia(){
            $.ajax({
            type:'POST',
            data:$('#modalAudienciaForm').serialize(),
            url:'/sicj/audienciaJuicio/save',
            success:function(data,textStatus){
            mostrarAudiencia(data);
            limpiarFormulario('modalAudienciaForm');
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            alert('algo fallo');
            }
            });
            return false;
            }

            function registrarAudienciaWF(){
            $.ajax({
            type:'POST',
            data:$('#modalAudienciaWFForm').serialize(),
            url:'/sicj/audienciaJuicio/save',
            success:function(data,textStatus){
            //mostrarAudiencia(data);
            limpiarFormulario('modalAudienciaWFForm');
            console.log("ESTE ES EL RESULTADO WF: " + resultado);
            $("#modalAltaAudienciaWF").modal('hide');
            document.getElementsByName("registrarAudienciaWF")[0].disabled = true;
            document.getElementsByName("botonGuardar")[0].disabled = false;
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            alert('algo fallo');
            }
            });
            return false;
            }
            
            function actualizarAudiencia(){
            jQuery.ajax({
            type:'POST',
            data:$('#editarAudienciaForm').serialize(),
            url:'/sicj/audienciaJuicio/update',
            success:function(data,textStatus){
            var respuesta = eval(data);
            if(respuesta.noDiferida){
            repintarAudiencia(respuesta.id, respuesta.color);
            } else {
            repintarAudiencia(respuesta.anterior, '#337ab7');
            mostrarAudiencia(data);
            }
            ocultarModal('modalDetalleAudiencia');
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            alert('algo fallo');
            }
            });
            return false
            }

            function validacionAudienciaEditada(){
            $("#editarAudienciaForm").validate({
            rules: {
            accionesAudiencia: { 
            required: function(element){
            return !($('[name="diferirAudiencia"]').is(':checked'));
            }
            },
            resultadoAudiencia: { 
            required: function(element){
            return !($('[name="diferirAudiencia"]').is(':checked'));
            }
            },  
            motivo: { 
            required: function(element){
            return $('[name="diferirAudiencia"]').is(':checked');
            }
            },  
            fechaAud: { 
            required: function(element){
            return $('[name="diferirAudiencia"]').is(':checked');
            }
            },
            hora: { 
            required: function(element){
            return $('[name="diferirAudiencia"]').is(':checked');
            }
            },
            nombreAsistente: "required"
            },
            messages: {
            accionesAudiencia: "Por favor indique las acciones de la audiencia",
            resultadoAudiencia: "Por favor indique el resultado de la audiencia",
            motivo: "Por favor indique el motivo",
            fechaAud: "Por favor indique la nueva fecha",
            hora: "Por favor indique la nueva hora",
            nombreAsistente: "Por favor indique el asistente"
            },
            submitHandler: function() {
            actualizarAudiencia();
            }
            });
            }

            function validacionCambiarEstado(){
            $('[name="cambiarEstadoJuicioForm"]').validate({
            ignore: [],
            rules: {
            estadoDelJuicio: "required",  
            observacionesFinales: "required",
            fechaDeTermino: "required",
            motivoDeTermino: "required",
            juicioPagado: "required",
            cantidadPagada: { 
            required: function(element){
            var respuesta = $('input[name="juicioPagado"]:checked').val();
            if(respuesta === 'SI'){
            return true;
            } else {
            return false;
            }
            },
            digits: true
            },  
            formaDePago: { 
            required: function(element){
            var respuesta = $('input[name="juicioPagado"]:checked').val();
            console.log("respuestaaaa: " + respuesta);
            if(respuesta === 'SI'){
            return true;
            } else {
            return false;
            }
            }
            }
            },
            messages: {
            estadoDelJuicio: "Por favor indique el estado del juicio",
            observacionesFinales: "Por favor haga las observaciones correspondientes",
            fechaDeTermino: "Por favor indique la fecha de termino",
            motivoDeTermino: "Por favor indique el motivo de termino",
            juicioPagado: "Por favor indique si el juicio fue pagado",
            cantidadPagada: {
            required: "Por favor indique la cantidad pagada",
            digits: "Por favor introduzca solo números enteros"
            },
            formaDePago: "Por favor indique la forma de pago"
            },
            submitHandler: function(form) {
            form.submit();
            },
            debug: true
            });
            }

            function validacionPreguntasWorkflow(){
            console.log("Si manda a llamar la validación");
            $("#workFlowForm").validate({
            errorElement: 'div',
            ignore: ":hidden:not(.chosen-select, #respuesta, #datoAuxiliar, #valorRespuesta)",
            errorPlacement: function(error, element) {
            error.insertBefore(element);
            },
            rules: {
            valorRespuesta: { 
            required: function(element){
            var tipoDePregunta = $('#tipoDePregunta').val();
            var obligatoria = $('#preguntaObligatoria').val();
            var valor = $('#valorRespuesta').val();
            var requerida = false;
            
            console.log("TIPO DE PREGUNTA - " + tipoDePregunta);
            console.log("OBLIGATORIA - " + obligatoria);
            console.log("VALOR - " + valor);
            console.log("REQUERIDA - " + requerida);
            
            if(tipoDePregunta === "FECHA" || tipoDePregunta === "TEXTO" || tipoDePregunta === "NUMERO" || tipoDePregunta === "TEXTAREA" || tipoDePregunta === "ARCHIVO"){
            if(obligatoria === "true"){
            requerida = true;
            }
            }
            return requerida;
            }
            },
            respuesta: {
            required: function(element){
            var tipoDePregunta = $('#tipoDePregunta').val();
            var obligatoria = $('#preguntaObligatoria').val();
            var requerida = false;
            if(tipoDePregunta === "RADIO" || tipoDePregunta === "SELECT"){
            if(obligatoria === "true"){
            requerida = true;
            }
            }
            return requerida;
            }
            },  
            respuestaCheck: {
            required: function(element){
            var tipoDePregunta = $('#tipoDePregunta').val();
            var obligatoria = $('#preguntaObligatoria').val();
            var requerida = false;
            if(tipoDePregunta === "CHECKBOX"){
            if(obligatoria === "true"){
            requerida = true;
            }
            }
            return requerida;
            }
            },  
            datoAuxiliar: {
            required: function(element){
            var auxiliar = $('#auxiliar').val();
            var obligatoria = $('#preguntaObligatoria').val();
            var requerida = false;
            if(auxiliar === "SI"){
            if(obligatoria === "true"){
            requerida = true;
            }
            }
            return requerida;
            }
            },
            observaciones: { 
            required: function(element){
            var tipoDePregunta = $('#tipoDePregunta').val();
            var obligatoria = $('#preguntaObligatoria').val();
            var requerida = false;
            var respuesta
            if(tipoDePregunta === "FECHA" || tipoDePregunta === "TEXTO" || tipoDePregunta === "NUMERO" || tipoDePregunta === "TEXTAREA" || tipoDePregunta === "ARCHIVO"){
                respuesta = $('[name="valorRespuesta"]').val();
            } else if(tipoDePregunta === "RADIO"){
                respuesta = $('input[name="respuesta"]:checked').val();
            } else if(tipoDePregunta === "SELECT"){
                respuesta = $('[name="respuesta"]').val();
            } else if(tipoDePregunta === "CHECKBOX"){
                respuesta = $('[name="respuestaCheck"]').val();    
            }
            console.log("Obligatorio? " + obligatoria + " - " + "Respuesta: " + respuesta + " - Tipo de Pregunta: " + tipoDePregunta);
            if(obligatoria === "false" && (respuesta === null || respuesta === undefined || respuesta === "")) {
            requerida = true;
            }
            return requerida;
            }
            }
            },
            messages: {
            valorRespuesta: "La pregunta indica es obligatoria, por favor proporcione el dato correspondiente.",
            respuesta: "La pregunta indica es obligatoria, por favor proporcione el dato correspondiente.",
            respuestaCheck: "La pregunta indica es obligatoria, por favor elija al menos una opción.",
            datoAuxiliar: "La pregunta indica es obligatoria, por favor proporcione el archivo correspondiente.",
            observaciones: "Debe proporcionar al menos la observación en el caso de no contar con la respuesta a la pregunta.",
            },
            submitHandler: function() {
            responderPreguntaWorkflow();
            }
            });
            }

            function responderPreguntaWorkflow(){
            $.ajax({
            type:'POST',
            data:$("#workFlowForm").serialize(), 
            url:'/sicj/juicio/registrarAvanceWorkFlow',
            success:function(data,textStatus){
            $('#divPreguntas').html(data);
            inicializarControles();
            validacionPreguntasWorkflow();
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            alert('algo fallo');
            }
            });
            return false;
            }

            function limpiarFormulario(idForm){
            $("#"+idForm).get(0).reset();
            $('#'+idForm + " .chosen-select").trigger("chosen:updated");
            }

            function eliminarArchivo(idJuicio, idArchivo){
            swal({
            title: "¿Está seguro?",
            text: "¡Una vez borrado ya no podrá recuperarlo!",
            type: "warning",
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Si, estoy seguro",
            closeOnConfirm: false
            }, function () {
            $.ajax({
            type:'POST',
            data: 'id=' + idArchivo + "&juicioId="+idJuicio,
            url:'/sicj/juicio/eliminarArchivo',
            success:function(data,textStatus){
            var respuesta = eval(data);
            if(respuesta.exito){
            mostrarArchivos(idJuicio);
            swal("¡Archivo eliminado correctamente!", respuesta.message, "success");
            } else{
            swal("!Algo fallo!", respuesta.message, "error");
            }
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            swal("!Algo fallo!", "Ocurrio un error grave al eliminar el archivo.", "error");
            }
            });
            return false;
            });
            }

            function buscarRespuestasDePregunta(idPregunta){
            var idJuicio = $('#reactivarJuicioId').val();
            var idTipoDeParte = $('#reactivarTipoDeParteId').val();
            $.ajax({
            type:'POST',
            data: 'idPreguntaAtendida=' + idPregunta + "&juicioId=" + idJuicio + "&tipoDeParteId=" + idTipoDeParte,
            url:'/sicj/juicio/obtenerRespuestasDePregunta',
            success:function(data,textStatus){
            $('#respuestaAEditar').html(data);
            inicializarControles();
            },error:function(XMLHttpRequest,textStatus,errorThrown){
            swal("!Algo fallo!", "Ocurrio un problema al consultar la respuesta de la pregunta indicada.", "error");
            }
            });
            }
        </script>
        <script type="text/javascript">
            $(document).ready(function() {
            
            $('.i-checks').iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green'
            });

            /* initialize the calendar
            -----------------------------------------------------------------*/
            var date = new Date();
            var d = date.getDate();
            var m = date.getMonth();
            var y = date.getFullYear();

            $('#calendar').fullCalendar({
            header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
            },
            weekends: false,
            editable: true,
            timezone: 'local',
            selectable: true,
            select:function(start, end, allDay) {
            $('#modalAltaAudiencia #divFechaAudiencia').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            calendarWeeks: true,
            daysOfWeekDisabled: [0,6],
            autoclose: true
            });
            $('#modalAltaAudiencia #divFechaAudiencia').datepicker('setUTCDate',new Date(start));
            $('#modalAltaAudiencia').modal();
            $('.clockpicker').clockpicker({
            autoclose: true
            });
            },
            events: {
            url: '/sicj/juicio/getAudiencias',
            type: 'POST',
            data: {
            juicioId: $('#provisionJuicioId').val(),
            tipo: 'juicio',
            vista: 'show'
            },
            error: function() {
            alert('Ocurrio un error al cargar las fechas de audiencia.');
            }
            },
            eventClick:  function(calEvent, jsEvent, view) {
            mostrarDetallesAudiencia(calEvent.id);
            return false;
            }
            });

            $('#modalCalendario').on('shown.bs.modal', function () {
            $("#calendar").fullCalendar('render');
            });
            //inicializarDropzone();
            mostrarArchivos(${juicio?.id});
            redimensionarChosen('divEtapasReactivar');
            $.validator.setDefaults({ ignore: ":hidden:not(.chosen-select)" });
            $("#modalAudienciaForm").validate({
            rules: {
            fechaAudiencia: "required",  
            horaAudiencia: "required",  
            tipoDeAudiencia: "required",  
            nombreAsistente: "required",
            },
            messages: {
            fechaAudiencia: "Por favor indique la fecha de la audiencia",
            horaAudiencia: "Por favor indique la hora de la audiencia",
            tipoDeAudiencia: "Por favor indique el tipo de audiencia",
            nombreAsistente: "Por favor indique el asistente"
            },
            submitHandler: function() {
            registrarAudiencia();
            document.getElementsByName("botonGuardar")[0].disabled = false;
            document.getElementsByName("registrarAudienciaWF")[0].disabled = true;
            }
            });
            
            if($("input:hidden[name=mensajeNotificacionJuicio]").val() > 0){
            //console.log("ENTRO AL MENSAJE NOTIFICACION");
            var y = $("input:hidden[name=mensajeNotificacionJuicio]").val();
            var html = "<div class='media-title alert alert-warning'><strong>Se encontro al finado duplicado</strong></div>"
            var mensaje = ""
            var warnings = 0;
                for (var x = 0; x < y; x++) {
                    mensaje = $("input:hidden[name=notificacionJuicio]").val();
                    html += "<li>";
                    html += "<div class='dropdown-messages-box'>";
                    html += "<div class='media-body alert alert-warning'><strong>";
                    html += mensaje;
                    html += "</strong></div>";
                    html += "</div>";
                    html += "</li>";
                    html += "<li class='divider'></li>";
                    warnings++;
                }
                $('#listaWarnings').html(html);
                $('#cantidadWarnings').html(warnings);
            } else {
                console.log("NO ESTA ENTRANDO ");
            }
            
            });
        </script>
        <script>
            var limiteDeArchivos = 0;
            var archivosSubidos = 0;
            var previewNode = document.querySelector("#template");
            previewNode.id = "";
            var previewTemplate = previewNode.parentNode.innerHTML;
            previewNode.parentNode.removeChild(previewNode);

            var myBodyDropzone = new Dropzone(document.body, {
            url: "/sicj/juicio/subirArchivo",
            uploadMultiple: true,
            parallelUploads: 1,
            paramName: "archivo",
            maxFiles: 5,
            maxFilesize: 20,
            acceptedFiles: ".pdf, .png, .jpg, application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, .csv, .xls, .xlsx",
            previewTemplate: previewTemplate,
            autoQueue: false,
            previewsContainer: "#previews",
            clickable: ".fileinput-button"
            });

            myBodyDropzone.on("totaluploadprogress", function(progress) {
            document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
            $('#total-progress .progress-bar').html("" + progress + " %");
            });

            myBodyDropzone.on("uploadprogress", function(file) {
            console.log(file.upload.progress);
            var progress = file.upload.progress;
            document.querySelector(".progress-bar-primary").style.width = progress + "%";
            $('.progress-bar-primary').html("" + progress + " %");
            });

            myBodyDropzone.on("successmultiple", function(files, response) {
            var respuesta = eval(response)
            if(respuesta.id){
            archivosSubidos++;
            $('.delete').hide();
            }
            });

            myBodyDropzone.on("sending", function(file) {
            document.querySelector("#total-progress").style.opacity = "1";
            });

            myBodyDropzone.on("queuecomplete", function(progress) {
            if(archivosSubidos == limiteDeArchivos){
            archivosSubidos = 0;
            $('#mensajesDropzone').html("<center><div class='alert alert-info'>Los archivos se han cargado correctamente.</div></center>");
            }
            });

            document.querySelector("#actions .start").onclick = function() {
            /*var materia = $('#materia').val();
            var delegacion = $('#delegacion').val();
            var transferirA = $('input:radio[name=transferirA]:checked').val();
            if(materia && delegacion && transferirA){
            cambiarParametros(materia, delegacion, transferirA);
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED));
            } else {
            mostrarAlert("!Importante¡", "Seleccione la materia y la delegación antes de intentar subir los archivos.", "warning");
            }*/
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED)); 
            cambiarParametros(${juicio?.id});
            };

            function cambiarParametros(juicioId) {
            myBodyDropzone.options.params = {'archivoJuicioId': juicioId};
            }
        </script>
    </body>
</html>
