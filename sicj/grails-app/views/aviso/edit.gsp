<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegacion')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
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
                        <strong>Edición de Avisos</strong>
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
                            <h5>Editar Aviso</h5>
                            <div class="ibox-tools">
                                <a style="color:#ffffff;" href="/sicj/aviso/index" class="btn btn-xs btn-warning">Ver Avisos</a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="message" role="status">${flash.message}</div>
                            </g:if>
                            <g:hasErrors bean="${this.aviso}">
                                <g:eachError bean="${this.aviso}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form resource="${this.aviso}" method="PUT" class="form-horizontal">
                                <g:hiddenField name="version" value="${this.aviso?.version}" />
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Titulo del aviso: </label>
                                    <div class="col-md-10">
                                        <div class="input-group">
                                            <input required name="tituloAviso" id="tituloAviso" type="text" value="${aviso.tituloAviso}" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase">
                                        </div> 
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Texto del aviso: </label>
                                    <div class="col-md-10">
                                        <div class="input-group">
                                            <textarea rows="4" cols="160" style="width: 95%;" required id="textoAviso" name='textoAviso' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase">${aviso.textoAviso}</textarea> 
                                        </div> 
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">Fecha de caducidad: </label>
                                    <div class="col-md-10">
                                        <div class="input-group date">
                                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input required readOnly name="fechaDeCaducidad" id="fechaDeCaducidad" type="text" value="${formatDate(format:'dd/MM/yyyy',date: aviso.fechaLimite)}" class="form-control">
                                        </div> 
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-md-4 col-md-offset-2">
                                        <g:link action='show' id='${aviso.id}' style="color:#ffffff;" class="btn btn-warning">Regresar</g:link>
                                        <g:submitButton class="btn btn-primary" name="update" value="Actualizar" />
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
