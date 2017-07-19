<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Delegaciones</a>
                    </li>
                    <li class="active">
                        <strong>Delegaciones Registradas</strong>
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
                            <h5>Lista de Delegaciones</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Id</th>
                                            <th>Delegación</th>
                                            <th>Zona</th>
                                            <th>Gerente Jurídico</th>
                                            <th>Ver Detalles</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in='${delegacionList}' status='i' var='delegacion'>
                                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td>${delegacion?.id}</td>
                                                <td>${delegacion?.nombre}</td>
                                                <td>${delegacion?.division}</td>
                                                <% def gerenteJuridico = delegacion.getGerenteJuridico(delegacion.id)%>
                                                <td><g:if test="${gerenteJuridico}">${gerenteJuridico?.nombre + " " + gerenteJuridico?.apellidoPaterno + " " + gerenteJuridico?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else></td>
                                                <td><g:link action='show' id='${delegacion.id}' class="btn-xs btn-info btn-bitbucket"><i class="fa fa-chevron-right"></i></g:link></td>
                                                </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination">
                                <g:paginate total="${delegacionCount ?: 0}" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>