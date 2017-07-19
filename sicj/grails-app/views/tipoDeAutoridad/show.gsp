<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'tipoDeAutoridad.label', default: 'TipoDeAutoridad')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Catálogos</a>
                    </li>
                    <li class="active">
                        <strong>Ver Tipo de Autoridad</strong>
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
                            <h5>Ver Tipo de Autoridad</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="index" style="color:#ffffff;">Lista de Tipos de Autoridad</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="table-responsive col-md-6">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Id</th>
                                                <th>Tipo de Autoridad</th>
                                                <th style="text-align: center;">Activo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>${tipoDeAutoridad?.id}</td>
                                            <td>${tipoDeAutoridad?.nombre}</td>
                                            <td align="center"><g:if test='${tipoDeAutoridad.activo}'><i class="fa fa-check text-navy"></i></g:if></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            <g:form resource="${this.tipoDeAutoridad}" method="DELETE">
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-6 col-lg-offset-2">
                                        <div class="form-group">
                                            <g:link class="edit" class="btn btn-primary" action="edit" resource="${this.tipoDeAutoridad}">Editar</g:link>
                                            <input class="btn btn-danger" type="submit" value="Eliminar" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                                        </div>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
