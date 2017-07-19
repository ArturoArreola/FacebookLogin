<!DOCTYPE html>
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
                        <a href="index.html">Autoridades</a>
                    </li>
                    <li class="active">
                        <strong>Autoridades Registradas</strong>
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
                            <h5>Lista de Autoridades</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:form class="form-horizontal">
                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-md-2 control-label">Delegación </label>
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'nombre')}" optionKey="id" onchange="obtenerListados(escape(this.value),'autoridad','obtenerTiposDeAutoridad');"/>
                                            </div>
                                        </div>
                                        <label class="col-md-2 control-label">Tipo de Autoridad </label>
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <select class="chosen-select" id="autoridad" name="autoridad.id" data-placeholder="Elija primero una Delegación..." style="width:350px;" tabindex="2">
                                                </select>  
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-7 col-sm-offset-2 text-center">
                                        <button class="btn btn-warning" type="reset" onclick="$('#resultados').html('');">Limpiar</button>
                                        <g:submitToRemote onSuccess="" onFailure="alert('algo fallo');" onComplete="" class="btn btn-primary" url="[controller: 'autoridad',action: 'doSearch']" update="resultados" method="POST" value="Buscar"/>
                                    </div>
                                </div>
                            </g:form>
                            <g:if test="${autoridadList}">
                                <div id="resultados">
                                    <g:render template="/templates/listaDeAutoridades"/>
                                </div>
                            </g:if>
                            <g:else>
                                <div id="resultados"></div>
                            </g:else>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function obtenerListados(delegacion,catalogo,metodo){
            $.ajax({
            type:'POST',
            data:'delegacion=' + delegacion,
            url:'/sicj/' + catalogo + '/' + metodo,
            success:function(data,textStatus){
            actualizar(data, catalogo);
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}});
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