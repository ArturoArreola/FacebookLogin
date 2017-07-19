<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
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
                        <strong>Datos del Aviso</strong>
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
                            <h5>Datos del Aviso</h5>
                            <div class="ibox-tools">
                                <a style="color:#ffffff;" href="/sicj/aviso/index" class="btn btn-xs btn-warning">Ver Avisos</a>
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
                                    <tbody>
                                        <tr>
                                            <th>Id</th><td>${aviso.id}</td>
                                        </tr>
                                        <tr>
                                            <th>Aviso</th><td><p><strong>${aviso.tituloAviso}</strong><br/><br/>${aviso.textoAviso}</p></td>
                                        </tr>
                                        <tr>
                                            <th>Fecha de Publicación</th><td><g:formatDate format="dd/MM/yyyy" date="${aviso.fechaDePublicacion}" /></td>
                                        </tr>
                                        <tr>
                                            <th>Creado por</th><td>${aviso.usuarioQueRegistro}</td>
                                        </tr>
                                        <tr>
                                            <th>Fecha de Caducidad</th><td><g:formatDate format="dd/MM/yyyy" date="${aviso.fechaLimite}" /></td>
                                        </tr>
                                        <tr>
                                            <th>Estado</th><td><span class="badge <g:if test="${aviso.activo}">badge-primary"></g:if><g:else>badge-danger"></g:else>${(aviso.activo) ? "VIGENTE" : "VENCIDO" }</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                <g:form resource="${this.aviso}" method="DELETE">
                                                    <g:link action='edit' id='${aviso.id}' class="btn btn-primary btn-xs">Editar</g:link>
                                                    <input class="btn btn-xs btn-danger" type="submit" value="Eliminar" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
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
