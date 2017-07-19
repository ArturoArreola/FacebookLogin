<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delito.label', default: 'Delito')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
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
                        <strong>Edición de Delitos</strong>
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
                            <h5>Editar Delito</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="show" style="color:#ffffff;" id="${this.delito.id}">Regresar</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.delito}">
                                <g:eachError bean="${this.delito}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form class="form-horizontal" resource="${this.delito}" method="PUT">
                                <g:hiddenField name="version" value="${this.delito?.version}" />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Nombre del Delito *</label>
                                    <div class="col-md-10">
                                        <input id="nombre" name="nombre" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" value="${delito?.nombre}" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Tipo de Asignación *</label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija una opción..." required class="chosen-select" style="width:350px;" tabindex="2" name="tipoDeAsignacion.id" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAsignacion.findAll("from TipoDeAsignacion ta Where ta.id > 0 Order by ta.nombre")}" value="${delito?.tipoDeAsignacion?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-6 col-lg-offset-2">
                                        <div class="form-group">
                                            <g:submitButton name="create" class="btn btn-warning" value="Actualizar" />
                                        </div>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
