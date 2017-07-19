<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Mi Perfil</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Usuario</a>
                    </li>
                    <li class="active">
                        <strong>Perfil</strong>
                    </li>
                </ol>
            </div>
        </div>
        <br/>
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row m-b-lg m-t-lg">
                <div class="col-md-5">

                    <div class="profile-image">
                        <img src="/sicj/assets/profile_small.png" class="img-circle circle-border m-b-md">
                    </div>
                    <div class="profile-info">
                        <div>
                            <div>
                                <h2 class="no-margins">
                                    ${usuario?.nombre + " " + usuario?.apellidoPaterno + " " + usuario?.apellidoMaterno}
                                </h2>
                                <g:if test="${usuario?.gerenteJuridico}">
                                    <h4>GERENTE JURÍDICO</h4>
                                </g:if>
                                <g:elseif test="${usuario?.responsableDelDespacho}">
                                    <h4>RESPONSABLE DEL DESPACHO</h4>
                                </g:elseif>    
                                <h4>
                                    ${usuario?.delegacion?.nombre}
                                    <g:if test="${usuario?.despacho && usuario?.despacho?.id > 0}">
                                    / ${usuario.despacho}
                                </g:if>
                            </h4>
                            <strong>Usuario: </strong> ${usuario?.username}<br/>
                            <strong>Email: </strong> ${usuario?.email}<br/>
                            <strong>Fecha de alta: </strong> ${usuario?.fechaDeRegistro}<br/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <table class="table small m-b-xs">
                    <thead>
                        <tr>
                            <th><strong> Estatus </strong></th>
                            <th><strong> Laboral </strong></th>
                            <th><strong> Civil </strong></th>
                            <th><strong> Penal </strong></th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:each var='registro' in='${juiciosPorUsuario}'>
                            <tr>
                                <td>
                                    <strong>${registro.estado?.nombre}</strong>
                                </td>
                                <td>
                                    ${registro.laboral}
                                </td>
                                <td>
                                    ${registro.civil}
                                </td>
                                <td>
                                    ${registro.penal}
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>
            <div class="col-md-2">
                <div class="ibox">
                    <div class="ibox-content">
                        <h3>Opciones</h3>
                        <center>
                            <ul class="list-unstyled file-list">
                                <li><a onclick="mostrarModal('modalCambiarPasswd');"><i class="fa fa-key"></i> Cambiar Contraseña</a></li>
                                <li><a href=""><i class="fa fa-envelope"></i> Editar Dirección de E-mail</a></li>
                            </ul>
                        </center>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal inmodal fade" id="modalCambiarPasswd" data-keyboard="false" data-backdrop="static" tabindex="-1"  role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                    <h5 class="modal-title">Cambiar Contraseña</h5>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning">
                        <strong>Importante: </strong> La nueva contraseña debe ser diferente a la contraseña actual, y debe contar con al menos 8 caracteres de longitud.
                    </div>
                    <div class="row">
                        <g:form id="modalClaveForm" name="modalClaveForm" style="margin: 0 auto; width: 50%; text-align: center;">
                            <input type="hidden" name="idUsuario" id="idUsuario" value="${usuario?.id}"/>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label">Contraseña Actual *</label>
                                        <div class="input-group">
                                            <input id="passActual" name="passActual" maxlength="80" style="width: 300px;" type="password" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label">Nueva Contraseña *</label>
                                        <div class="input-group">
                                            <input id="nuevoPass" name="nuevoPass" maxlength="80" style="width: 300px;" type="password" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label">Repita Nueva Contraseña *</label>
                                        <div class="input-group">
                                            <input id="repiteNuevoPass" name="repiteNuevoPass" maxlength="80" style="width: 300px;" type="password" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
                                    </div>
                                </div>
                            </div>
                        </g:form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function mostrarModal(modal){
        $('#'+modal).modal('show');
        }

        function ocultarModal(modal){
        $('#'+modal).modal('hide');
        }

        function actualizarClave(){
        jQuery.ajax({
        type:'POST',
        data:$('#modalClaveForm').serialize(),
        url:'/sicj/perfilDeUsuario/actualizarClave',
        success:function(data,textStatus){
        var respuesta = eval(data);
        if(respuesta.exito){
        ocultarModal('modalCambiarPasswd');
        swal({title: "¡Acción Completada!",text: respuesta.mensaje, type: "success"});
        } else {
        swal({title: "¡Atención!",text: respuesta.mensaje, type: "warning"});
        }
        ocultarModal('modalDetalleAudiencia');
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        swal({title: "¡Error!",text: "Ocurrio un error al intentar actualizar. Intentelo nuevamente más tarde.", type: "error"});
        }
        });
        return false
        }

        $(document).ready(function() {
        $.validator.addMethod("notEqualTo", function(value, element) {
        return $('#passActual').val() != $('#nuevoPass').val()
        }, "La nueva contraseña debe ser diferente a la actual");

        $("#modalClaveForm").validate({
        rules: {
        passActual: { 
        required: true
        },
        nuevoPass: { 
        required: true,
        minlength: 8,
        notEqualTo: true
        },  
        repiteNuevoPass: {
        required:  true,
        minlength: 8,
        equalTo : "#nuevoPass"
        }
        },
        messages: {
        passActual: {
        required: "Por favor indique la contraseña actual"
        },
        nuevoPass: {
        required: "Por favor indique la nueva contraseña",
        minlength: "La contraseña debe ser de al menos 8 caracteres"
        },
        repiteNuevoPass: { 
        required: "Por favor repita la nueva contraseña",
        equalTo: "La nueva contraseña no coincide",
        minlength: "La contraseña debe ser de al menos 8 caracteres"
        }
        },
        submitHandler: function() {
        actualizarClave();
        }
        });
        });
    </script>
</body>
</html>