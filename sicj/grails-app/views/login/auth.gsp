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
        <link href="/sicj/assets/style.css" type="text/css" rel="stylesheet" media="screen, projection" dir="assets/css" file="style.css">
    </head>
    <body class="gray-bg">
        <div class="middle-box text-center loginscreen animated fadeInDown">
            <div>
                <div>
                    <img src="/sicj/assets/infonavit-logo.png" width="70%" height="70%">
                </div>
                <br/>
                <h3>Módulo de Control de Juicios</h3>

                <g:if test='${flash.message}'>
                    <br/>
                    <div class="alert alert-danger alert-dismissable">
                        <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                        El usuario y/o la contraseña no son válidos.
                    </div>
                </g:if>

                <p>Ingresa tu Usuario y Contraseña</p>
                <form action="${postUrl ?: '/sicj/login/authenticate'}" method="POST" id="loginForm" autocomplete="off" class="m-t" role="form">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Usuario" name="${usernameParameter ?: 'username'}" id="username"/>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" placeholder="Contraseña" name="${passwordParameter ?: 'password'}" id="password">
                    </div>
                    <button type="submit" class="btn btn-primary block full-width m-b"
                    value="${message(code: 'springSecurity.login.button')}">Ingresar</button>
                </form>
                <p class="m-t"> <small>Infonavit &copy; 2017</small> </p>
            </div>
        </div>
        <!-- Mainly scripts -->
        <script src="/sicj/assets/jquery-2.1.1.js" type="text/javascript" dir="assets/js" file="jquery-2.1.1.js"></script>
        <script src="/sicj/assets/bootstrap.min.js" type="text/javascript" dir="assets/js" file="bootstrap.min.js"></script>
    </body>
</html>
