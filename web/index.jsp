<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWT with MongoDB</title>
        <script type="text/javascript" src="Resources/dynamsoft.webtwain.initiate.js"></script>
        <script type="text/javascript" src="Resources/dynamsoft.webtwain.config.js"></script>
        <style>
            h1 {
                font-size: 2em;
                font-weight: bold;
                color: #777777;
                text-align: center
            }

            table {
                margin: auto;
            }
        </style>
    </head>

    <body>
        <h1>
            DWT with MongoDB
        </h1>
        <table>
            <tr>
                <td>
                    <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
                   If you need to rename the id, you should also change the id in dynamsoft.webtwain.config.js accordingly. -->
                    <div id="dwtcontrolContainer"></div>
                </td>
            </tr>

            <tr>
                <td>
                    <input type="button" value="Load" onclick="btnLoad_onclick();" />
                    <input type="button" value="Scan" onclick="AcquireImage();" />
                    <input id="btnUpload" type="button" value="Save to MongoDB" onclick="btnUpload_onclick()">
                </td>
            </tr>
        </table>

        <!--Custom script goes here-->
        <script type="text/javascript">
            Dynamsoft.WebTwainEnv.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady);
            var DWObject;

            function Dynamsoft_OnReady() {
                DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer');    // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
                DWObject.Width = 480;       // Set the width of the Dynamic Web TWAIN Object
                DWObject.Height = 640;      // Set the height of the Dynamic Web TWAIN Object
            }

            function btnLoad_onclick() {
                var OnSuccess = function() {
                };

                var OnFailure = function(errorCode, errorString) {
                };

                DWObject.IfShowFileDialog = true;
                DWObject.LoadImageEx("", EnumDWT_ImageType.IT_ALL, OnSuccess, OnFailure);
            }

            function AcquireImage() {
                if (DWObject) {
                    DWObject.IfShowUI = false;
                    DWObject.IfDisableSourceAfterAcquire = true;	// Scanner source will be disabled/closed automatically after the scan.
                    DWObject.SelectSource();                        // Select a Data Source (a device like scanner) from the Data Source Manager.
                    DWObject.OpenSource();                          // Open the source. You can set resolution, pixel type, etc. after this method. Please refer to the sample 'Scan' -> 'Custom Scan' for more info.
                    DWObject.AcquireImage();                        // Acquire image(s) from the Data Source. Please NOTE this is a asynchronous method. In other words, it doesn't wait for the Data Source to come back.
                }
            }

            function btnUpload_onclick() {
                DWObject.HTTPPort = 8080;
                var CurrentPathName = unescape(location.pathname); // get current PathName in plain ASCII
                var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
                var strActionPage = CurrentPath + "DWTUpload";
                var strHostIP = "localhost"; // server IP e.g. 192.168.8.84

                var OnSuccess = function(httpResponse) {
                    alert("Succesfully uploaded");
                };

                var OnFailure = function(errorCode, errorString, httpResponse) {
                    alert(httpResponse);
                };

                var date = new Date();
                DWObject.HTTPUploadThroughPostEx(
                        strHostIP,
                        DWObject.CurrentImageIndexInBuffer,
                        strActionPage,
                        date.getTime() + ".jpg",
                        1, // JPEG
                        OnSuccess, OnFailure
                        );
            }
        </script>
    </body>
</html>
