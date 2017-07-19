<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'despacho.label', default: 'Despacho')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Despachos</a>
                    </li>
                    <li class="active">
                        <strong>Datos del Despacho</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuAdmin"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Datos del Despacho</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:if test="${flash.error}">
                                <div class="alert alert-danger alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.error}
                                </div>
                            </g:if>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Nombre del Despacho</th>
                                            <th>Delegación</th>
                                            <th>Zona</th>
                                            <th>Responsable</th>
                                            <th>Opciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>${despacho?.nombre}</td>
                                            <td>${despacho?.delegacion}</td>
                                            <td>${despacho?.delegacion?.division}</td>
                                            <td><g:if test="${responsableDelDespacho}">${responsableDelDespacho?.nombre + " " + responsableDelDespacho?.apellidoPaterno + " " + responsableDelDespacho?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else></td>
                                                <td>
                                                <g:form resource="${this.despacho}" method="DELETE">
                                                    <g:link action='index' class="btn btn-xs btn-warning">Regresar</g:link>
                                                    <g:link action='edit' id='${despacho.id}' class="btn btn-primary btn-xs">Editar</g:link>
                                                    <g:if test="${despacho?.activo}">
                                                        <input type="submit" class="btn btn-danger btn-xs" onclick="return confirm('¿Está seguro?');" value="Dar de Baja" />
                                                    </g:if>
                                                    <g:else>
                                                        <input type="button" class="btn btn-warning btn-xs" data-toggle="modal" data-target="#modalTransferencia" value="Transferir Asuntos" />
                                                    </g:else>    
                                                </g:form>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Usuarios Adscritos al Despacho</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" >
                                    <thead>
                                        <tr>
                                            <th>Nombre del Usuario</th>
                                            <th>Activo</th>
                                            <th>Bloqueado</th>
                                            <th>Fecha de Alta</th>
                                            <th>Fecha de Baja</th>
                                            <th>Bloquear</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><th colspan="6" style="text-align: center;"><strong>Usuarios Activos</strong></th></tr>
                                                <g:each in='${usuariosDespachoList.findAll{ it.enabled == true}}' status='i' var='usuario'>
                                            <tr class="gradeX">
                                                <td>${usuario?.nombre + " " + usuario?.apellidoPaterno + " " + usuario?.apellidoMaterno} </td>
                                                <td align="center"><g:if test='${usuario.enabled}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                <td align="center"><g:if test='${usuario?.accountLocked}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                <td>${usuario?.fechaDeRegistro}</td>
                                                <td>${usuario?.fechaDeBloqueo}</td>
                                                <td>
                                                    <g:if test="${usuario?.enabled}">
                                                        <g:link controller='user' action='bloquearUsuario' params="[id: usuario.id, despacho: despacho.id]" class="btn btn-xs btn-danger">Bloquear</g:link>
                                                    </g:if>
                                                </td>
                                            </tr>
                                        </g:each>
                                        <tr><th colspan="6" style="text-align: center;"><strong>Usuarios Bloqueados</strong></th></tr>
                                                <g:each in='${usuariosDespachoList.findAll{ it.enabled == false}}' status='i' var='usuario'>
                                            <tr class="gradeX">
                                                <td>${usuario?.nombre + " " + usuario?.apellidoPaterno + " " + usuario?.apellidoMaterno} </td>
                                                <td align="center"><g:if test='${usuario.enabled}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                <td align="center"><g:if test='${usuario?.accountLocked}'><i class="fa fa-check text-navy"></i></g:if></td>
                                                <td>${usuario?.fechaDeRegistro}</td>
                                                <td>${usuario?.fechaDeBloqueo}</td>
                                                <td>
                                                    <g:if test="${usuario?.enabled}">
                                                        <g:link controller='user' action='bloquearUsuario' params="[id: usuario.id, despacho: despacho.id]" class="btn btn-xs btn-danger">Bloquear</g:link>
                                                    </g:if>
                                                </td>
                                            </tr>
                                        </g:each>
                                        <g:if test="${(usuariosDespachoList.findAll{ it.enabled == false} == null) || (usuariosDespachoList.findAll{ it.enabled == false})?.size() == 0}">
                                            <tr class="gradeX"><td colspan="6" style="text-align: center;">No hay usuario bloqueados</td></tr>
                                        </g:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <g:if test="${!despacho?.activo}">
            <div class="modal inmodal fade" id="modalTransferencia" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg" style="width: 80%;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                            <h5 class="modal-title">Reasignar Juicios del Despacho<br /> ${despacho}</h5>
                        </div>
                        <div class="modal-body">
                            <div id="divArchivosDelJuicio">
                                <g:render template="/templates/transferirJuicios"/>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </g:if>
    </body>
</html>
