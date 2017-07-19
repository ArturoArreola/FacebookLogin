<html>
    <head>
        <meta name="layout" content="inspinia"/>
    <s2ui:title messageCode='Buscar Usuario'/>
</head>
<body>
    <div class="row wrapper border-bottom white-bg page-heading">
        <div class="col-sm-4">
            <h2>Cónsola de Administración</h2>
            <ol class="breadcrumb">
                <li>
                    <a href="index.html">Usuarios</a>
                </li>
                <li class="active">
                    <strong>Buscar Usuario</strong>
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
                        <h5>Buscar Usuario</h5>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="ibox-content">
                                <div class="row">
                                    <div class="form-group" id='usuarioRemote'>
                                        <label class="col-sm-2 control-label">Nombre del usuario:</label>
                                        <div class="col-sm-10">
                                            <input id="usuario" style="width:295px;" name='usuario' type="text" placeholder="Buscar usuario..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >  
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="resultadoUsuarios"></div>
    </div>
    <script type="text/javascript">
        function obtenerUsuario(idPersona){
        var idUsuario = eval(idPersona);
        jQuery.ajax({
        type:'POST',
        data:'id=' + idUsuario.id,
        url:'/sicj/user/obtenerUsuario',
        success:function(data,textStatus){
        $('#resultadoUsuarios').html(data);
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }
    </script>    
    <script type="text/javascript">
        $(document).ready(function(){
        var bestPictures = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: '/sicj/user/searchByNombre',
        remote: {
        url: '/sicj/user/searchByNombre?query=%QUERY',
        wildcard: '%QUERY'
        }
        });
        $('#usuarioRemote .typeahead').typeahead({minLength: 2}, {
        name: 'usuario',
        display: 'value',
        source: bestPictures,
        limit: 20,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al usuario en el apartado correspondiente.',
            '</div>'
        ].join('\n')
        }
        });
        $('#usuarioRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        obtenerUsuario(suggestion);
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
