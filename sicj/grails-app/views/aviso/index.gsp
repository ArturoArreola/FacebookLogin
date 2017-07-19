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
                        <a href="index.html">Avisos</a>
                    </li>
                    <li class="active">
                        <strong>Avisos Registrados</strong>
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
                            <h5>Lista de Aviso</h5>
                            <div class="ibox-tools">
                                <a style="color:#ffffff;" href="/sicj/aviso/create" class="btn btn-xs btn-warning">Nuevo Aviso</a>
                            </div>
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
                                            <th style="text-align: center;">Aviso</th>
                                            <th style="text-align: center;">Fecha de Publicación</th>
                                            <th style="text-align: center;">Estado</th>
                                            <th style="text-align: center;">Ver Detalles</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <g:each in='${avisoList}' status='i' var='aviso'>
                                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td><p><strong>${aviso.tituloAviso}</strong><br/><br/>${aviso?.textoAviso}</p></td>
                                                <td style="text-align: center;"><g:formatDate format="dd/MM/yyyy" date="${aviso.fechaDePublicacion}" /></td>
                                                <td style="text-align: center;"><span class="badge <g:if test="${aviso.activo}">badge-primary"></g:if><g:else>badge-danger"></g:else>${(aviso.activo) ? "VIGENTE" : "VENCIDO" }</span></td>
                                                <td style="text-align: center;"><g:link action='show' id='${aviso.id}' class="btn-xs btn-info btn-bitbucket"><i class="fa fa-chevron-right"></i></g:link></td>
                                                </tr>
                                        </g:each>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination">
                                <g:paginate total="${avisoCount ?: 0}" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>