<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'despacho.label', default: 'Despacho')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
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
                        <strong>Despachos Registrados</strong>
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
                            <h5>Lista de Despachos</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:form action="index" class="form-horizontal">
                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-md-2 control-label">Buscar </label>
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <input type="text" name="busquedaDespacho" id="busquedaDespacho" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="width: 350px;" placeholder="Nombre del Despacho"/>
                                            </div>
                                        </div>
                                        <div class="col-sm-7 text-center">
                                            <button class="btn btn-warning" type="reset">Limpiar</button>
                                            <button class="btn btn-primary" type="submit">Buscar</button>
                                        </div>
                                    </div>
                                </div>
                            </g:form>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th style="text-align: center;">Nombre del Despacho</th>
                                            <th style="text-align: center;">Delegación</th>
                                            <th style="text-align: center;">Zona</th>
                                            <th style="text-align: center;">Responsable</th>
                                            <th style="text-align: center;">¿Despacho Activo?</th>
                                            <th style="text-align: center;">Ver Detalles</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in='${despachoList}' status='i' var='despacho'>
                                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td style="text-align: center;">${despacho?.nombre}</td>
                                                <td style="text-align: center;">${despacho?.delegacion}</td>
                                                <td style="text-align: center;">${despacho?.delegacion?.division}</td>
                                                <% def responsableDelDespacho = despacho.getResponsable(despacho.id)%>
                                                <td style="text-align: center;"><g:if test="${responsableDelDespacho}">${responsableDelDespacho?.nombre + " " + responsableDelDespacho?.apellidoPaterno + " " + responsableDelDespacho?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else></td>
                                                <td style="text-align: center;"><g:if test="${despacho?.activo}"><span class="badge badge-primary">SI</span></g:if><g:else><span class="badge badge-danger">NO</span></g:else></td>
                                                <td style="text-align: center;"><g:link action='show' id='${despacho.id}' class="btn-xs btn-info btn-bitbucket"><i class="fa fa-chevron-right"></i></g:link></td>
                                                </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination">
                                <g:if test="${busquedaDespacho}">
                                    <g:paginate action="index" total="${despachoCount ?: 0}" params="${[busquedaDespacho: busquedaDespacho]}"/>
                                </g:if>
                                <g:else>
                                    <g:paginate total="${despachoCount ?: 0}" />
                                </g:else>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>