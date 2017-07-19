<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'tipoAsociado.label', default: 'Tipo Asociad')}" />
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
                        <strong>Registro de Tipos Asociados</strong>
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
                            <h5>Registrar Tipo Asociado</h5>
                            <div class="ibox-tools">
                                <g:link class="btn btn-xs btn-primary" action="index" style="color:#ffffff;">Lista de Tipos Asociados</g:link>
                                </div>
                            </div>
                            <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.tipoAsociado}">
                                <g:eachError bean="${this.tipoAsociado}" var="error">
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
                                    <label class="col-md-2 control-label">Nombre del Tipo Asociado *</label>
                                    <div class="col-md-10">
                                        <input id="nombre" name="nombre" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Materia *</label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select noSelection="['':'Elija la materia...']" data-placeholder="Elija la materia..." required class="chosen-select" style="width:350px;" tabindex="2" name="materia.id" from="${mx.gox.infonavit.sicj.catalogos.Materia.findAll('from Materia m where m.id in (1,2) order by m.id')}" optionKey="id" onchange="obtenerPrestacionesReclamadas(escape(this.value));"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Prestación Reclamada *</label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <select class="chosen-select" required id="prestacionReclamada" name="prestacionReclamada.id" data-placeholder="Elija primero la materia..." style="width:300px;" tabindex="2">
                                            </select> 
                                        </div>
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
        <script>
            function obtenerPrestacionesReclamadas(materiaId){
            jQuery.ajax({
            type:'GET',
            data: "materiaId=" + materiaId,
            url:'/sicj/tipoAsociado/obtenerPrestacionesReclamadas',
            success:function(data,textStatus){
            actualizar(data, 'prestacionReclamada');
            $('#prestacionReclamada').trigger("chosen:updated");
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
            html += "<option value='null'>Elija una opción...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#' + tipo).html(html);
            $('#' + tipo).trigger("chosen:updated");
            }
        </script>
    </body>
</html>
