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
                        <a href="index.html">Autoridades</a>
                    </li>
                    <li class="active">
                        <strong>Datos de la Autoridad</strong>
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
                            <h5>Datos de la Autoridad</h5>
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
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th style="text-align: center;">Id</th>
                                            <th style="text-align: center;">Materia</th>
                                            <th style="text-align: center;">Ambito</th>
                                            <th style="text-align: center;">Estado/Municipio</th>
                                            <th style="text-align: center;">Tipo de Autoridad</th>
                                            <th style="text-align: center;">Autoridad</th>
                                            <th style="text-align: center;">¿Vigente?</th>
                                            <th style="text-align: center;">Opciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td style="text-align: center;">${autoridad?.id}</td>
                                            <td style="text-align: center;">${autoridad?.materia}</td>
                                            <td style="text-align: center;">${autoridad?.ambito}</td>
                                            <td style="text-align: center;">${autoridadMunicipio?.municipio?.estado} <strong>/</strong> ${autoridadMunicipio?.municipio}</td>
                                            <td style="text-align: center;">${autoridad?.tipoDeAutoridad}</td>
                                            <td style="text-align: center;">${autoridad?.nombre}</td>
                                            <td style="text-align: center;"><g:if test="${autoridad?.activo}"><span class="badge badge-primary">SI</span></g:if><g:else><span class="badge badge-danger">NO</span></g:else></td>
                                            <td  style="text-align: center;">
                                                <g:form resource="${this.autoridad}" method="DELETE">
                                                    <g:link action='index' class="btn btn-xs btn-warning">Regresar</g:link>
                                                    <g:link action='edit' id='${autoridad.id}' class="btn btn-primary btn-xs">Editar</g:link>
                                                    <input type="submit" class="btn btn-danger btn-xs" onclick="return confirm('¿Está seguro?');" value="Eliminar" />
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
        </div>
    </body>
</html>