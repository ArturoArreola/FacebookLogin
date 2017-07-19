<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'tipoDeAudiencia.label', default: 'Tipo de Audiencia')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
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
                        <strong>Lista Tipos de Audiencia</strong>
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
                            <h5>Lista de Tipos de Audiencia</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="create" style="color:#ffffff;">Nuevo Tipo de Audiencia</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="message" role="status">${flash.message}</div>
                            </g:if>
                            <div class="row">
                                <div class="table-responsive col-md-8">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Id</th>
                                                <th>Nombre</th>
                                                <th>Materia</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each in="${tipoDeAudienciaList}" status="i" var="tipoDeAudiencia">
                                                <tr>
                                                    <td><g:link class="btn btn-xs btn-outline btn-link" action="show" id="${tipoDeAudiencia.id}">${tipoDeAudiencia?.id}</g:link></td>
                                                    <td>${tipoDeAudiencia?.nombre}</td>
                                                    <td>${tipoDeAudiencia?.materia}</td>
                                                </tr>
                                            </g:each>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="pagination row">
                                <g:paginate total="${tipoDeAudienciaCount ?: 0}" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>