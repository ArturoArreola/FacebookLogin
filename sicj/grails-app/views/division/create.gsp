<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'division.label', default: 'División')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
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
                        <strong>Registro de Zonas</strong>
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
                            <h5>Registrar Zona</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="index" style="color:#ffffff;">Lista de Zonas</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.division}">
                                <g:eachError bean="${this.division}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form class="form-horizontal" action="save">
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Nombre de la Zona *</label>
                                    <div class="col-md-10">
                                        <input id="nombre" name="nombre" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Descripción *</label>
                                    <div class="col-md-10">
                                        <input id="descripcion" name="descripcion" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Valor Mínimo *</label>
                                    <div class="col-md-10">
                                        <input id="valorMinimo" name="valorMinimo" type="number" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Valor Máximo *</label>
                                    <div class="col-md-10">
                                        <input id="valorMaximo" name="valorMaximo" type="number" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="row">
                                    <div class="col-lg-6 col-lg-offset-2">
                                        <div class="form-group">
                                            <g:submitButton name="create" class="btn btn-success" value="Guardar" />
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
