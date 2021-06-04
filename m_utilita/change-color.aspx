<%@ Page Language="C#" AutoEventWireup="true" CodeFile="change-color.aspx.cs" Inherits="Templates_TemplateForm" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<!-- Jquery per Uploader  -->
<script src="/timereport/include/uploader/jquery.ui.widget.js"></script>
<script src="/timereport/include/uploader/load-image.all.min.js"></script>
<script src="/timereport/include/uploader/canvas-to-blob.min.js"></script>
<script src="/timereport/include/uploader/jquery.iframe-transport.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-process.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-image.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-validate.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground" id="test">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
                    </div>

                    <div class="accordion" id="accordionExample">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                    Colore
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                <div class="accordion-body  justify-content-center row">
                                    <div class="col-2 squaredBox pickColor" style="background-color: #1874cd"></div>
                                    <div class="col-2 squaredBox pickColor" style="background-color: #008B8B"></div>
                                    <div class="col-2 squaredBox pickColor" style="background-color: #c0c0c0"></div>
                                    <div class="col-2 squaredBox pickColor" style="background-color: #8fbc8f"></div>
                                    <div class="col-2 squaredBox pickColor" style="background-color: #8b2500"></div>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    Sfondo
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                                <div class="accordion-body justify-content-center row">
                                    <div class="col-2 squaredBox pickImg" style="background-size: 150px; background-image: url('/timereport/images/background/choice/bkgr1.jpg')"></div>
                                    <div class="col-2 squaredBox pickImg" style="background-size: 150px; background-image: url('/timereport/images/background/choice/bkgr2.jpg')"></div>
                                    <div class="col-2 squaredBox pickImg" style="background-size: 150px; background-image: url('/timereport/images/background/choice/bkgr3.jpg')"></div>
                                    <div class="col-2 squaredBox pickImg" style="background-size: 150px; background-image: url('/timereport/images/background/choice/bkgr4.jpg')"></div>
                                    <div class="col-2 squaredBox pickImg" style="background-size: 150px; background-image: url('/timereport/images/background/choice/bkgr5.jpg')"></div>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingThree">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                    Personalizza
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                                <div class="accordion-body">
                                    <div class="form-group">
                                        <label for="exampleFormControlFile1">Carica Immagine</label>
                                        <input type="file" class="form-control-file" id="CaricaImmagine" name="files[]">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Per passare al backend la scelta dei colori-->
                    <asp:HiddenField ID="BackgroundColor" runat="server" />
                    <asp:HiddenField ID="BackgroundImg" runat="server" />

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <div id="valMsg" class="col parsely-single-error"></div>
                        <asp:Button ID="UpdateCancelButton" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="ButtonClick" formnovalidate />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- *** End container *** -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.CutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // Lingua
        window.Parsley.setLocale('<%=Session["lingua"]%>');

        // *** Validazione che richiama un servizio, bisogna mettere il tag data-parsley-username sull'elemento del form *** //
        window.Parsley.addValidator('username', function (value, requirement) {
            var response = false;
            var dataAjax = "{ sPassword: '" + value + "' , " + " sUserName: '<%=CurrentSession.Persons_id%>' }"

            $.ajax({
                url: "/timereport/webservices/WStimereport.asmx/CheckPassword",
                data: dataAjax,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false,
                success: function (data) {
                    if (data.d == "false")
                        response = false;
                    else
                        response = true;
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(thrownError);
                }
            });
            return response;
        }, 32)
            .addMessage('en', 'username', 'Password not valid')
            .addMessage('it', 'username', 'Password non valida');

        $('#FVMain').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        $('.pickColor').click(function () {
            $('#BackgroundColor').val($(this).css('background-color')); // colore da passare al backend con il post
            $('.MainWindowBackground').css("background-color", $(this).css('background-color'));
            $('#BackgroundImg').val("");  // resetta immagine
            $('.MainWindowBackground').css("background-image", "");
        });

        $('.pickImg').click(function () {
            $('#BackgroundImg').val($(this).css('background-image')); // colore da passare al backend con il post
            $('.MainWindowBackground').css("background-image", $(this).css('background-image'));
            $('.MainWindowBackground').css("background-size", "cover");
            $('#BackgroundColor').val(""); // resetta colore
            $('.MainWindowBackground').css("background-color", "");
        });

        // Initialize the jQuery File Upload widget:  
        $('#CaricaImmagine').fileupload({
            // i parametri addizionali vengono letti dal form e passati nella url
            url: "/timereport/webservices/carica_immagine.ashx",
            dataType: 'json',
            // caricamento parte alla selezione del file
            autoUpload: true,
            // Allowed file types and size
            acceptFileTypes: /(jpg)|(jpeg)|(png)$/i,
            // Resize immagini
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator && navigator.userAgent),
            imageMaxWidth: 3000,
            imageMaxHeight: 2000,
            imageCrop: false, // no cropped images
            // progress bar (vedi elemento con classe bar nel form di upload)
            progress: function (e, data) {
                //var bar = $('.bar');
                //var progress = parseInt(data.loaded / data.total * 100, 10);
                //var percentVal = progress + '%';
                //bar.width(percentVal);
            },
        })
            .bind('fileuploaddone', function (e, data) {
                $('#BackgroundImg').val("url('" + data.result + "')"); // url tornato dal servizio
                // forza refresh il cambio url
                const randomId = new Date().getTime();
                $('.MainWindowBackground').css("background-image", "url('" + data.result + "?random=" + randomId + "')");
                $('.MainWindowBackground').css("background-size", "cover");
            })
            .bind('fileuploadfail', function (e, data) {
                alert("errore nel caricamento del file");
            })

    </script>

</body>

</html>




