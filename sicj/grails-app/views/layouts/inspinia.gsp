<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Control de Juicios</title>
        <link rel="shortcut icon" href="/sicj/assets/favicon.ico" type="image/x-icon"> 
        <link href="/sicj/assets/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/css" file="bootstrap.min.css">
        <link href="/sicj/assets/css/font-awesome.min.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/css" file="font-awesome.min.css">
        <link href="/sicj/assets/animate.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/css" file="animate.css">
        <link href="/sicj/assets/plugins/iCheck/custom.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/iCheck" file="custom.css">
        <link href="/sicj/assets/plugins/switchery/switchery.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/switchery" file="switchery.css">
        <link href="/sicj/assets/plugins/chosen/chosen.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/chosen" file="chosen.css">
        <link href="/sicj/assets/style.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/css" file="style.css">
        <!-- Data Tables -->
        <!--<link href="/sicj/assets/plugins/dataTables/dataTables.bootstrap.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.bootstrap.css"/>-->
        <!--<link href="/sicj/assets/plugins/dataTables/dataTables.responsive.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.responsive.css"/>-->
        <!--<link href="/sicj/assets/plugins/dataTables/dataTables.tableTools.min.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/dataTables" file="dataTables.tableTools.min.css"/>-->
         <!-- jQuery Steps-->
        <link href="/sicj/assets/plugins/steps/jquery.steps.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/steps" file="jquery.steps.css">
         <!-- Tagsinput-->
        <link href="/sicj/assets/plugins/tagsinput/bootstrap-tagsinput.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/tagsinput" file="bootstrap-tagsinput.css">
                <!-- Full Calendar CSS-->
        <link href="/sicj/assets/plugins/fullcalendar/fullcalendar.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/fullcalendar" file="fullcalendar.css">
        <link href="/sicj/assets/plugins/fullcalendar/fullcalendar.print.css" type="text/css" rel="stylesheet" dir="assets/plugins/fullcalendar" file="fullcalendar.print.css" media="print">
         <!-- Mainly scripts -->
        <script src="/sicj/assets/numbersOnly.js" type="text/javascript" dir="assets/javascripts" file="numbersOnly.js"></script>
        <script src="/sicj/assets/jquery-2.1.3.js" type="text/javascript" dir="assets/js" file="jquery-2.1.3.js"></script>
        <script src="/sicj/assets/bootstrap.min.js" type="text/javascript" dir="assets/js" file="bootstrap.min.js"></script>
        <script src="/sicj/assets/plugins/metisMenu/jquery.metisMenu.js" type="text/javascript" dir="assets/plugins/metisMenu" file="jquery.metisMenu.js"></script>
        <script src="/sicj/assets/plugins/slimscroll/jquery.slimscroll.min.js" type="text/javascript" dir="assets/plugins/slimscroll" file="jquery.slimscroll.min.js"></script>
        <!-- Custom and plugin javascript -->
        <script src="/sicj/assets/inspinia.js" type="text/javascript" dir="assets/js" file="inspinia.js"></script>
        <script src="/sicj/assets/plugins/pace/pace.min.js" type="text/javascript" dir="assets/plugins/pace" file="pace.min.js"></script>
        <!-- jQuery UI custom -->
        <script src="/sicj/assets/jquery-ui.custom.min.js" type="text/javascript" dir="assets/js" file="jquery-ui.custom.min.js"></script>
        <!-- iCheck -->
        <script src="/sicj/assets/plugins/iCheck/icheck.min.js" type="text/javascript" dir="assets/plugins/iCheck" file="icheck.min.js"></script>
        <link href="/sicj/assets/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/awesome-bootstrap-checkbox" file="awesome-bootstrap-checkbox.css">
        <!--DatePicker-->
        <link href="/sicj/assets/plugins/datapicker/datepicker3.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/plugins/datapicker" file="datepicker3.css">
        <!-- Switchery -->
        <script src="/sicj/assets/plugins/switchery/switchery.js" type="text/javascript" dir="assets/plugins/switchery" file="switchery.js"></script>
        <!-- Chosen -->
        <script src="/sicj/assets/plugins/chosen/chosen.jquery.js" type="text/javascript" dir="assets/plugins/chosen" file="chosen.jquery.js"></script>
        <!-- Data Tables -->
        <!--<script src="/sicj/assets/plugins/dataTables/jquery.dataTables.js" type="text/javascript" dir="assets/plugins/dataTables" file="jquery.dataTables.js"></script>-->
        <!--<script src="/sicj/assets/plugins/dataTables/dataTables.bootstrap.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.bootstrap.js"></script>-->
        <!--<script src="/sicj/assets/plugins/dataTables/dataTables.responsive.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.responsive.js"></script>-->
        <!--<script src="/sicj/assets/plugins/dataTables/dataTables.tableTools.min.js" type="text/javascript" dir="assets/plugins/dataTables" file="dataTables.tableTools.min.js"><script>-->
        <!-- Steps -->
        <script src="/sicj/assets/plugins/staps/jquery.steps.min.js" type="text/javascript" dir="assets/plugins/staps" file="jquery.steps.min.js"></script>
        <!-- Jquery Validate -->
        <script src="/sicj/assets/plugins/validate/jquery.validate.min.js" type="text/javascript" dir="assets/plugins/validate" file="jquery.validate.min.js"></script>
        <!-- Data picker -->
        <script src="/sicj/assets/plugins/datapicker/bootstrap-datepicker.js" type="text/javascript" dir="assets/plugins/datapicker" file="bootstrap-datepicker.js"></script>
        <!-- TypeAhead -->
        <script src="/sicj/assets/plugins/typeahead/typeahead.js" type="text/javascript" dir="assets/plugins/typeahead" file="typeahead.js"></script>
        <!-- Tagsinput -->
        <script src="/sicj/assets/plugins/tagsinput/bootstrap-tagsinput.min.js" type="text/javascript" dir="assets/plugins/tagsinput" file="bootstrap-tagsinput.min.js"></script>
        <!-- Input Mask-->
        <script src="/sicj/assets/plugins/jasny/jasny-bootstrap.min.js" type="text/javascript" dir="assets/plugins/jasny" file="jasny-bootstrap.min.js"></script>
        <!-- Full Calendar -->
        <script src="/sicj/assets/plugins/fullcalendar/moment.min.js" type="text/javascript" dir="assets/plugins/fullcalendar" file="moment.min.js"></script>
        <script src="/sicj/assets/plugins/fullcalendar/fullcalendar.min.js" type="text/javascript" dir="assets/plugins/fullcalendar" file="fullcalendar.min.js"></script>
        <script src="/sicj/assets/plugins/fullcalendar/lang/es.js" type="text/javascript" dir="assets/plugins/fullcalendar/lang" file="es.js"></script>
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
        <g:layoutHead />
    </head>
    <body class="">
        <div id="wrapper">
            <nav class="navbar-default navbar-static-side" role="navigation">
                <div class="sidebar-collapse">
                    <ul class="nav metismenu" id="side-menu">
                        <li class="nav-header">
                            <div class="dropdown profile-element"> <span>
                                   <img src="/sicj/assets/profile_small.png" class="img-circle">
                                </span>
                                <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                    <span class="clear"> <span class="block m-t-xs">
                                            ¡Bienvenido(a)!<br/><strong class="font-bold"><sec:loggedInUserInfo field='fullName'/></strong><br />
                                        </span>
                                    </span>
                                </a>
                                <ul class="dropdown-menu animated fadeInRight m-t-xs">
                                    <li><g:link controller="perfilDeUsuario" action="index">Perfil</g:link></li>
                                        <li class="divider"></li>
                                        <li><a href="/sicj/logoff">Salir</a></li>
                                    </ul>
                                </div>
                                <div class="logo-element">
                                <img src="/sicj/assets/infonavit-logo.png" width="80%" height="80%">
                            </div>
                        </li>
                        <g:render template="/templates/menu"/>
                    </ul>
                </div>
            </nav>

            <div id="page-wrapper" class="gray-bg">
                <div class="row border-bottom">
                    <nav class="navbar navbar-static-top  " role="navigation" style="margin-bottom: 0">
                        <div class="navbar-header">
                            <a class="navbar-minimalize minimalize-styl-2 btn btn-primary "><i class="fa fa-bars"></i> </a>
                            <form role="search" style="width: 70%;" class="navbar-form-custom">
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-md-6">
                                            <div class="input-group">
                                                <select class="form-control" name="tipoDeConsulta">
                                                    <option value="1" selected>Expediente Interno</option>
                                                    <option value="12">Expediente del Juicio</option>
                                                    <option value="10">Número de Crédito</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="input-group">
                                                <input type="text" style="width: 220px;" maxlength="30" type="text" onBlur="this.value=this.value.toUpperCase();" placeholder="Búsqueda rápida..." class="form-control" name="busquedaExternaExpediente" id="busquedaExternaExpediente">
                                                <span class="input-group-btn">
                                                    <g:submitToRemote onSuccess="abrirModalResultados();" onFailure="alert('algo fallo');" onComplete="cerrarSpinner()" before="abrirSpinner()" class="btn btn-primary dim" url="[controller: 'juicio',action: 'realizarBusqueda']" update="resultadosLayout" method="POST" value="Buscar"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <ul class="nav navbar-top-links navbar-right tooltip-demo">
                            <li>
                                <span class="m-r-sm text-muted welcome-message">Módulo de Control de Juicios</span>
                            </li>
                            <li class="dropdown" data-toggle="tooltip" data-placement="left" title="Errores">
                                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                    <i class="fa fa-times-circle"></i>  <span id="cantidadErrores" class="label label-danger">0</span>
                                </a>
                                <ul id="listaErrores" class="dropdown-menu dropdown-messages">
                                </ul>
                            </li>
                            <li class="dropdown" data-toggle="tooltip" data-placement="left" title="Notificaciones">
                                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                    <i class="fa fa-warning"></i>  <span id="cantidadWarnings" class="label label-warning">0</span>
                                </a>
                                <ul id="listaWarnings" class="dropdown-menu dropdown-messages">
                                </ul>
                            </li>
                            <li class="dropdown" data-toggle="tooltip" data-placement="left" title="Recordatorios">
                                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                    <i class="fa fa-bell"></i>  <span class="label label-primary">0</span>
                                </a>
                                <ul class="dropdown-menu dropdown-alerts">
                                </ul>
                            </li>


                            <li>
                                <a href="/sicj/logoff">
                                    <i class="fa fa-sign-out"></i> Salir
                                </a>
                            </li>
                        </ul>

                    </nav>
                </div>
                <div class="wrapper wrapper-content">
                    <g:layoutBody />
                </div>
                <div class="footer">
                    <div class="pull-right">
                        <strong>Copyright</strong> Infonavit &copy; 2017
                    </div>
                </div>
            </div>
            <div class="modal inmodal fade" id="modalResultados" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg" style="width: 1100px;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                            <h4 class="modal-title">Resultados de la Búsqueda</h4>
                        </div>
                        <div id="resultadosLayout"></div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal inmodal fade in" id="spinnerModal" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Espere por favor...</h4>
                        </div>
                        <div class="modal-body">
                            <div class="spiner-example">
                                <div class="sk-spinner sk-spinner-wave">
                                    <div class="sk-rect1"></div>
                                    <div class="sk-rect2"></div>
                                    <div class="sk-rect3"></div>
                                    <div class="sk-rect4"></div>
                                    <div class="sk-rect5"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $(document).ready(function () {
            $('.i-checks').iCheck({
            radioClass: 'iradio_square-green'
            });
            $('.input-group.date').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            format: 'dd/mm/yyyy',
            todayHighlight: true,
            calendarWeeks: true,
            daysOfWeekDisabled: [0,6],
            autoclose: true
            });
            var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
            elems.forEach(function(html) {
            var switchery = new Switchery(html);
            });
            var config = {
            '.chosen-select'           : {width:"300px"},
            '.chosen-select-deselect'  : {allow_single_deselect:true},
            '.chosen-select-no-single' : {disable_search_threshold:10},
            '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
            '.chosen-select-width'     : {width:"95%"}
            }
            for (var selector in config) {
            $(selector).chosen(config[selector]);
            }
            });
        </script>
        <script>
            function abrirModalResultados(){
            $('#modalResultados').modal('show');
            }

            function abrirSpinner(){
            $('#spinnerModal').modal('show');
            }

            function cerrarSpinner(){
            $('#spinnerModal').modal('hide');
            }
        </script>
    </body>
</html>