<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'tipoDeAutoridad.label', default: 'Tipo de Audiencia')}" />
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
                        <strong>Ver Tipo de Audiencia</strong>
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
                            <h5>Ver Tipo de Audiencia</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="index" style="color:#ffffff;">Lista de Tipos de Audiencia</g:link>
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
                            <div class="table-responsive col-md-6">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Id</th>
                                            <th>Nombre</th>
                                            <th>Materia</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>${tipoDeAudiencia?.id}</td>
                                            <td>${tipoDeAudiencia?.nombre}</td>
                                            <td>${tipoDeAudiencia?.materia}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <g:form resource="${this.tipoDeAudiencia}" method="DELETE">
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-6 col-lg-offset-2">
                                        <div class="form-group">
                                            <g:link class="edit" class="btn btn-primary" action="edit" resource="${this.tipoDeAudiencia}">Editar</g:link>
                                            <input class="btn btn-danger" type="submit" value="Eliminar" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: '¿Está seguro?')}');" />
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
