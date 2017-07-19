<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'tipoAsociado.label', default: 'Tipo Asociado')}" />
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
                        <strong>Lista de Tipos Asociados</strong>
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
                            <h5>Lista de Tipos Asociados</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="create" style="color:#ffffff;">Nuevo Tipo Asociado</g:link>
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
                                                <th>Prestacion Reclamada</th>
                                                <th>Materia</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each in="${tipoAsociadoList}" status="i" var="tipoAsociado">
                                                <tr>
                                                    <td><g:link class="btn btn-xs btn-outline btn-link" action="show" id="${tipoAsociado.id}">${tipoAsociado?.id}</g:link></td>
                                                    <td>${tipoAsociado?.nombre}</td>
                                                    <td>${tipoAsociado?.prestacionReclamada}</td>
                                                    <td>${tipoAsociado?.prestacionReclamada?.materia}</td>
                                                </tr>
                                            </g:each>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="pagination row">
                                <g:paginate total="${tipoAsociadoCount ?: 0}" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>