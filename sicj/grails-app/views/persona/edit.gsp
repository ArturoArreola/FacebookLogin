<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="inspinia"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sample title</title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Actores</a>
                    </li>
                    <li class="active">
                        <strong>Edición de Actores</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuAdmin"/>
            <div class="row">
                <div class="col-lg-6">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Editar Actor</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${params.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${params.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.persona}">
                                <g:eachError bean="${this.persona}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form action="update" method="PUT" class="form-horizontal">
                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-md-4 control-label">Buscar Actor</label>
                                        <div class="col-md-8">
                                            <div class="input-group m-b" id='actorRemote'>
                                                <input id="actor" style="width:295px;" name='actor' type="text" placeholder="Escriba el nombre" class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="datosActor"></div>
                            </g:form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Juicios en los que aparece el Actor</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <div id="verJuiciosDelActor"></div>
                            </div>
                            <div class="row">
                                <div id="listaJuicios"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function obtenerDatosActor(seleccion){
            var actor = eval(seleccion);
            jQuery.ajax({
            type:'GET',
            url:'/sicj/persona/obtenerPersona',
            data: 'idActor=' + actor.id,
            success:function(data,textStatus){
            if(data.notFound){
            $('#datosActor').html(data.mensaje);
            } else {
            $('#datosActor').html(data);
            $('#tipoDePersona').chosen({
            width: "300px"
            });
            $('#actorRemote .typeahead').typeahead('val', "");
            $('#verJuiciosDelActor').html("<div class='form-group text-center'><div class='col-lg-12'><button type='button' class='btn btn-info' onclick='obtenerJuiciosDelActor("+actor.id+");'><i class='fa fa-list'></i>&nbsp;&nbsp;Ver Juicios Asociados</button></div></div>");
            }
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function obtenerJuiciosDelActor(actor){
            jQuery.ajax({
            type:'GET',
            url:'/sicj/persona/obtenerJuiciosDelActor',
            data: 'idActor=' + actor,
            success:function(data,textStatus){
            if(data.notFound){
            $('#listaJuicios').html(data.mensaje);
            } else {
            $('#listaJuicios').html(data);
            }
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }
        </script>    
        <script>
            $(document).ready(function(){
            var bestPictures = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: '/sicj/persona/buscarActores',
            remote: {
            url: '/sicj/persona/buscarActores?query=%QUERY',
            wildcard: '%QUERY'
            }
            });
            $('#actorRemote .typeahead').typeahead({minLength: 3}, {
            name: 'actor',
            display: 'value',
            source: bestPictures,
            limit: 25,
            templates: {
            empty: [
                '<div class="empty-message">',
            'No existen coincidencias. Por favor verifique que este bien escrito el nombre de la persona',
                '</div>'
            ].join('\n')
            }
            });
            $('#actorRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
            obtenerDatosActor(suggestion);
            });
            });
        </script>
        <style type="text/css">
            .typeahead, .tt-query, .tt-hint {
            border: 1px solid #CCCCCC;
            border-radius: 8px;
            line-height: 15px;
            outline: medium none;
            padding: 8px 12px;
            width: 300px;
            }
            .typeahead {
            background-color: #FFFFFF;
            }
            .typeahead:focus {
            border: 2px solid #0097CF;
            }
            .tt-query {
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            }
            .tt-hint {
            color: #999999;
            }
            .tt-menu {
            background-color: #FFFFFF;
            border: 1px solid rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            margin-top: 12px;
            padding: 8px 0;
            width: 300px;
            }
            .tt-suggestion {
            line-height: 24px;
            padding: 3px 20px;
            }
            .tt-suggestion.tt-is-under-cursor {
            background-color: #0097CF;
            color: #FFFFFF;
            }
            .tt-suggestion p {
            margin: 0;
            }
        </style>
    </body>
</html>
