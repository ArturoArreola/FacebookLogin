<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'formaDePago.label', default: 'Forma de Pago')}" />
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
                        <strong>Lista de Formas de Pago</strong>
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
                            <h5>Lista de Formas de Pago</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="create" style="color:#ffffff;">Nueva Forma de Pago</g:link>
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
                                                <th style="text-align: center;">¿Activa?</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each in="${formaDePagoList}" status="i" var="formaDePago">
                                                <tr>
                                                    <td><g:link class="btn btn-xs btn-outline btn-link" action="show" id="${formaDePago.id}">${formaDePago?.id}</g:link></td>
                                                    <td>${formaDePago?.nombre}</td>
                                                    <td style="text-align: center;"><g:if test="${formaDePago?.activo}"><span class="badge badge-primary">SI</span></g:if><g:else><span class="badge badge-danger">NO</span></g:else></td>
                                                </tr>
                                            </g:each>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="pagination row">
                                <g:paginate total="${formaDePagoCount ?: 0}" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>