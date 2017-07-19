<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Autoridad')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
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
                        <strong>Edición de Autoridades</strong>
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
                            <h5>Editar Autoridad</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.autoridad}">
                                <g:eachError bean="${this.autoridad}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form action="update" method="PUT" class="form-horizontal">
                                <input type="hidden" name="id" value="${autoridad?.id}">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Materia: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija la materia..." required class="chosen-select" style="width:350px;" tabindex="2" name="materia.id" from="${mx.gox.infonavit.sicj.catalogos.Materia?.list(sort:'id')}" value="${autoridad?.materia?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Ámbito: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija un Ámbito..." required class="chosen-select" style="width:350px;" tabindex="2" name="ambito.id" from="${mx.gox.infonavit.sicj.catalogos.Ambito?.list(sort:'nombre')}" value="${autoridad?.ambito?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Estado: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select noSelection="['':'Elija el Estado...']" required data-placeholder="Elija el Estado..." class="chosen-select" style="width:300px;" tabindex="2" name="estado.id" id="estado" value="${autoridadMunicipio.municipio.estado.id}" from="${mx.gox.infonavit.sicj.catalogos.Estado?.list(sort:'nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerMunicipios', params : '\'estado=\' + escape(this.value)', onSuccess : 'actualizar(data,\'municipio\')')}"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Municipio: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select noSelection="['':'Elija el Municpio...']" required data-placeholder="Elija el Municipio..." class="chosen-select" style="width:300px;" tabindex="2" name="municipio.id" id="municipio" value="${autoridadMunicipio.municipio.id}" from="${listaMunicipios}" optionKey="id"/>    
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Tipo de Autoridad: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija el Tipo de Autoridad..." required class="chosen-select" style="width:350px;" tabindex="2" name="tipoDeAutoridad.id" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAutoridad?.list(sort:'nombre')}" value="${autoridad?.tipoDeAutoridad?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group"><label class="col-sm-2 control-label">Nombre de la Autoridad: </label>
                                    <div class="col-sm-10"><input type="text" required class="form-control" name='nombre' size='50' maxlength='255' autocomplete='off' value='${autoridad.nombre}' onBlur="this.value=this.value.toUpperCase();"/></div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-md-2 control-label">¿Activa? </label>
                                    <div class="col-md-6">
                                        <g:checkBox id="activo" name="activo"  class="js-switch" checked="${autoridad?.activo}" value="${autoridad?.activo}" />
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <g:link action='show' id='${autoridad.id}' class="btn btn-warning">Regresar</g:link>
                                        <button class="btn btn-primary" type="submit">Guardar</button>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
        html += "<option value='null'>Elija un Municipio...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#municipio').html(html);
            $('#municipio').trigger("chosen:updated");
            }
        </script>
    </body>
</html>
