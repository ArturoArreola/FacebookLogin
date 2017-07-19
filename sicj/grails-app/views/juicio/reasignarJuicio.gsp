<!DOCTYPE html>
<html>
    <head>

        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title>Control de Juicios</title>
        <!-- DROPZONE -->
        <g:external dir="assets/plugins/dropzone" file="basic.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.js" />
        <script src="/sicj/assets/jquery_binary.js" type="text/javascript" dir="assets" file="jquery_binary.js"></script>
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
        <!-- Data Tables -->
        <g:external dir="assets/plugins/dataTables" file="dataTables.bootstrap.css" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.responsive.css" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.tableTools.min.css" />
        <g:external dir="assets/plugins/dataTables" file="buttons.dataTables.min.css" />
        <g:external dir="assets/plugins/dataTables/latest" file="jquery.dataTables.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="dataTables.buttons.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.flash.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="jszip.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="pdfmake.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="vfs_fonts.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.html5.min.js" />
        <g:external dir="assets/plugins/dataTables/latest" file="buttons.print.min.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.bootstrap.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.responsive.js" />
        <g:external dir="assets/plugins/dataTables" file="dataTables.tableTools.min.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Control de Juicios</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/juicio/search">Juicios</a>
                    </li>
                    <li class="active">
                        <strong>Reasignación de Juicios</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuJuicios"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Reasignación de Juicios</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <center>    
                                <div class="alert alert-info">
                                    <strong>Importante:</strong> Es responsabilidad del usuario subir el archivo correspondiente a la delegación seleccionada.
                                </div>
                            </center>
                            <g:render template="/templates/transferirJuicios" />
                            <br />
                            <br />
                            <div id="cargaArchivos" class="row">
                                <g:render template="/templates/subirArchivos" />
                            </div>
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table id="tablaErrores" class="table table-striped table-bordered table-hover dataTables" style="overflow-x: auto; display: none;">
                                        <thead>
                                            <tr>
                                                <th>Expediente Interno</th>
                                                <th>Delegacion</th>
                                                <th>Materia</th>
                                                <th>Estado de Juicio</th>
                                            </tr>
                                        </thead>
                                        <tbody id="bodyTablaErrores">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function mostrarAlert(titulo, mensaje, tipo){
            swal({
            title: titulo,
            text: mensaje,
            type: tipo
            });
            }
        </script>    
        <script>
            var limiteDeArchivos = 0;
            var archivosSubidos = 0;
            var registrosConError = 1;
            var previewNode = document.querySelector("#template");
            previewNode.id = "";
            var previewTemplate = previewNode.parentNode.innerHTML;
            previewNode.parentNode.removeChild(previewNode);

            var myBodyDropzone = new Dropzone(document.body, {
            url: "/sicj/juicio/cargarReporte",
            uploadMultiple: true,
            parallelUploads: 1,
            paramName: "archivo",
            maxFiles: 5,
            acceptedFiles: "application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, .csv, .xls, .xlsx",
            previewTemplate: previewTemplate,
            autoQueue: false,
            previewsContainer: "#previews",
            clickable: ".fileinput-button"
            });

            myBodyDropzone.on("totaluploadprogress", function(progress) {
            document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
            $('#total-progress .progress-bar').html("" + progress + " %");
            });

            myBodyDropzone.on("uploadprogress", function(file) {
            console.log(file.upload.progress);
            var progress = file.upload.progress;
            document.querySelector(".progress-bar-primary").style.width = progress + "%";
            $('.progress-bar-primary').html("" + progress + " %");
            });

            myBodyDropzone.on("successmultiple", function(files, response) {
            var html = "";
            var respuesta = eval(response);
            var resultado = respuesta.existenciaRegistros;
            console.log("Respuesta -> " + respuesta.existenciaRegistros);
            console.log("Cantidad de juicios erroneos -> " + resultado.length);
            if (resultado.length >= 1){
            $('#mensaje').html("<center><div class='alert alert-warning'><p><strong>Se encontraron anomalías en  "+resultado.length+" juicio(s) al realizar la reasignación</strong></p></br><p>Por favor verifique que los campos de origen y destino de la delegación y despacho hayan sido seleccionados de manera correcta al igual que la opción de reasignación</p></div></center>");
            //$('#botonDescarga').show('slow');
            for(var x = 0; x < resultado.length; x++){
                //console.log("VALOR DE X -> " + x);
                html += "<tr>"
                html += "<td>"+resultado[x].juicioId.expedienteInterno+"</td>"
                html += "<td>"+resultado[x].delegacionId.nombre+"</td>"
                html += "<td>"+resultado[x].materiaId.nombre+"</td>"
                html += "<td>"+resultado[x].estadoDeJuicioId.nombre+"</td>"
                html += "</tr>"
            }
            $('#bodyTablaErrores').html(html);
            $('#tablaErrores').show('slow').DataTable({
            dom: 'Bfrtip',
            buttons: [{
                extend: 'excelHtml5',
                title: 'reporteErroresReasignacion'
            }]
            });
            $('.delete').hide('slow');
            } else {
            $('#mensaje').html("<center><div class='alert alert-success'><strong>Los juicios se han reasignado de manera correcta</strong></div></center>");
            $('.delete').hide();
            }
            });

            myBodyDropzone.on("sending", function(file) {
            document.querySelector("#total-progress").style.opacity = "1";
            });

            myBodyDropzone.on("queuecomplete", function(progress) {
            if(archivosSubidos == limiteDeArchivos){
            archivosSubidos = 0;
            $('#mensajesDropzone').html("<center><div class='alert alert-info'>Los archivos se han cargado correctamente.</div></center>");
            }
            });

            document.querySelector("#actions .start").onclick = function() {
            var delegacionOrigen = $('#delegacionOrigen').val();
            var despachoOrigen = $('#despachoOrigen').val();
            var delegacionDestino = $('#delegacionDestino').val();
            var despachoDestino = $('#despachoDestino').val();
            var opcion = $('#opcion').val();
            
            if(opcion == 1){
            if(delegacionOrigen && despachoOrigen && delegacionDestino && despachoDestino && opcion){
            cambiarParametros(delegacionOrigen, despachoOrigen, delegacionDestino, despachoDestino, opcion);
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED));
            }
            }
            else if(opcion == 3){
            if(delegacionOrigen && delegacionDestino && opcion){
            despachoOrigen = (delegacionOrigen * -1) -1;             //  Valor para una delegacion NINGUNO
            despachoDestino = (delegacionDestino * -1) -1;           //  Valor para una delegacion NINGUNO
            cambiarParametros(delegacionOrigen, despachoOrigen, delegacionDestino, despachoDestino, opcion);
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED));
            }
            }
            else if(opcion == 4){
            if(delegacionOrigen && delegacionDestino && despachoDestino && opcion){
            despachoOrigen = (delegacionOrigen * -1) -1;            //  Valor por default para una delegacion NINGUNO
            cambiarParametros(delegacionOrigen, despachoOrigen, delegacionDestino, despachoDestino, opcion);
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED));
            }
            }
            else {
            mostrarAlert("¡Importante!", "Seleccione la opción deseada, así como la delegación, el despacho de origen y destino antes de intentar subir los archivos.", "warning");
            }
            };

            function cambiarParametros(delegacionOrigen, despachoOrigen, delegacionDestino, despachoDestino, opcion) {
            myBodyDropzone.options.params = {'delegacionOrigen': delegacionOrigen, 'despachoOrigen': despachoOrigen, 'delegacionDestino': delegacionDestino, 'despachoDestino': despachoDestino, 'opcion': opcion};
            }
        </script>
    </body>
</html>
