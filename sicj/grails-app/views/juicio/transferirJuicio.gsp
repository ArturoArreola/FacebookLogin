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
                        <strong>Transferencia de Juicios</strong>
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
                            <h5>Transferencia de Juicios</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <center>    
                                <div class="alert alert-info">
                                    <strong>Importante:</strong> Es responsabilidad del usuario subir el archivo correspondiente a la materia seleccionada.
                                </div>
                            </center>   
                            <form class="form-horizontal">
                                <fieldset>
                                    <div class="form-group">
                                        <label class="col-md-2 control-label">¿Qué desea realizar?</label>
                                        <div class="col-md-10">
                                            <div class="input-group">
                                                <div class="radio radio-success radio-inline">
                                                    <input type="radio" name="transferirA" id="transferirAT" value="2">
                                                    <label for="transferirAT">
                                                        Transferir a Terminado
                                                    </label>
                                                </div>
                                                <div class="radio radio-success radio-inline">
                                                    <input type="radio" name="transferirA" id="transferirAAD" value="6">
                                                    <label for="transferirAAD">
                                                        Transferir a Archivo Definitivo
                                                    </label>
                                                </div>
                                                <div class="radio radio-success radio-inline">
                                                    <input type="radio" name="transferirA" id="transferirAAH" value="7">
                                                    <label for="transferirAAH">
                                                        Transferir a Archivo Histórico
                                                    </label>
                                                </div>
                                            </div>  
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-2 control-label">Seleccione la Materia:</label>
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <g:select noSelection="['':'Elija una Materia...']" data-placeholder="Elija una Materia..." class="chosen-select" style="width:300px;" tabindex="2" name="materia.id" id="materia" from="${mx.gox.infonavit.sicj.catalogos.Materia?.list(sort:'id')}" value="" optionKey="id" />
                                            </div>
                                        </div>
                                        <label class="col-md-2 control-label">Seleccione la Delegación:</label>
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'nombre')}" optionKey="id" />
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>    
                            </form>
                            <br />
                            <br />
                            <div class="row">
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
            var previewNode = document.querySelector("#template");
            previewNode.id = "";
            var previewTemplate = previewNode.parentNode.innerHTML;
            previewNode.parentNode.removeChild(previewNode);

            var myBodyDropzone = new Dropzone(document.body, {
            url: "/sicj/juicio/cargarReporteTransferencia",
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
            $('#mensaje').html("<center><div class='alert alert-warning'><p><strong>Se encontraron anomalías en  "+resultado.length+" juicio(s) al realizar la transferencia</strong></p></br><p>Por favor verifique que los campos de origen y destino de la delegación y despacho hayan sido seleccionados de manera correcta al igual que la opción de transferencia</p></div></center>");
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
                title: 'reporteErroresTransferencia'
            }]
            });
            $('.delete').hide('slow');
            } else {
            $('#mensaje').html("<center><div class='alert alert-success'><strong>Los juicios se han transferido de manera correcta</strong></div></center>");
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
            var materia = $('#materia').val();
            var delegacion = $('#delegacion').val();
            var transferirA = $('input:radio[name=transferirA]:checked').val();
            if(materia && delegacion && transferirA){
            cambiarParametros(materia, delegacion, transferirA);
            myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED));
            } else {
            mostrarAlert("!Importante¡", "Seleccione la materia y la delegación antes de intentar subir los archivos.", "warning");
            }
            };

            function cambiarParametros(materiaId, delegacionId, transferirA) {
            myBodyDropzone.options.params = {'materiaId': materiaId, 'delegacionId': delegacionId, 'transferirA': transferirA};
            }
        </script>
    </body>
</html>
