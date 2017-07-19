<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'despacho.label', default: 'Despacho')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Despachos</a>
                    </li>
                    <li class="active">
                        <strong>Edición de Despachos</strong>
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
                            <h5>Editar Despacho</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.despacho}">
                                <g:eachError bean="${this.despacho}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form resource="${this.despacho}" method="PUT" class="form-horizontal">
                                <g:hiddenField name="version" value="${this.despacho?.version}" />
                                <div class="form-group"><label class="col-sm-2 control-label">Nombre del Despacho: </label>
                                    <div class="col-sm-10"><input type="text" class="form-control" name='nombre' size='50' maxlength='255' autocomplete='off' value='${despacho?.nombre}' onBlur="this.value=this.value.toUpperCase();"/></div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Delegación: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija una Delegación..." class="chosen-select" style="width:350px;" tabindex="2" name="delegacion.id" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list()}" value="${despacho?.delegacion?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <g:link action='show' id='${despacho.id}' class="btn btn-warning">Regresar</g:link>
                                        <button class="btn btn-primary" type="submit">Guardar</button>
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
