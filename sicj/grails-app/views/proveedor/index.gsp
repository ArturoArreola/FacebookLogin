<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'proveedor.label', default: 'Proveedor')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Proveedors</a>
                    </li>
                    <li class="active">
                        <strong>Proveedors Registrados</strong>
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
                            <h5>Lista de Proveedores</h5>
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
                                                <input type="text" name="busquedaProveedor" id="busquedaProveedor" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="width: 350px;" placeholder="Nombre del Proveedor"/>
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
                                            <th style="text-align: center;">Nombre del Proveedor</th>
                                            <th style="text-align: center;">Delegación</th>
                                            <th style="text-align: center;">Zona</th>
                                            <th style="text-align: center;">Responsable</th>
                                            <th style="text-align: center;">¿Proveedor Activo?</th>
                                            <th style="text-align: center;">Ver Detalles</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in='${proveedorList}' status='i' var='proveedor'>
                                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td style="text-align: center;">${proveedor?.nombre}</td>
                                                <td style="text-align: center;">${proveedor?.delegacion}</td>
                                                <td style="text-align: center;">${proveedor?.delegacion?.division}</td>
                                                <% def responsable = proveedor.getResponsable(proveedor.id)%>
                                                <td style="text-align: center;"><g:if test="${responsable}">${responsable?.nombre + " " + responsable?.apellidoPaterno + " " + responsable?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else></td>
                                                <td style="text-align: center;"><g:if test="${proveedor?.activo}"><span class="badge badge-primary">SI</span></g:if><g:else><span class="badge badge-danger">NO</span></g:else></td>
                                                <td style="text-align: center;"><g:link action='show' id='${proveedor.id}' class="btn-xs btn-info btn-bitbucket"><i class="fa fa-chevron-right"></i></g:link></td>
                                                </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination">
                                <g:if test="${busquedaProveedor}">
                                    <g:paginate action="index" total="${proveedorCount ?: 0}" params="${[busquedaProveedor: busquedaProveedor]}"/>
                                </g:if>
                                <g:else>
                                    <g:paginate total="${proveedorCount ?: 0}" />
                                </g:else>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>