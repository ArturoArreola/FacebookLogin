<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'perfil.label', default: 'Perfil')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Perfiles</a>
                    </li>
                    <li class="active">
                        <strong>Creación de Perfiles</strong>
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
                            <h5>Crear Perfil</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.perfil}">
                                <g:eachError bean="${this.perfil}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form action="save" class="form-horizontal">
                                <div class="form-group"><label class="col-sm-2 control-label">Nombre del Perfil: </label>
                                    <div class="col-sm-10"><input type="text" class="form-control" name='name' size='50' maxlength='255' autocomplete='off' value='${perfil.name}' onBlur="this.value=this.value.toUpperCase();"/></div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <g:link action='index' class="btn btn-warning">Regresar</g:link>
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
