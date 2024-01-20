# IIS installation script
import-module servermanager
add-windowsfeature Web-server -includeallsubfeature

# Web app update script
$HTMLContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Updated Web App</title>
</head>
<body>
    <h1>Updated Web App with Static Content</h1>
    
    <!-- Image Container -->
    <div id="imageContainer">
        <!-- Image will be dynamically set here using JavaScript -->
    </div>

    <!-- JavaScript to set the image source -->
    <script>
        // Replace this URL with the actual static content URL
        const imageUrl = "https://storagegee2.blob.core.windows.net/container1/cloud-image.jpg";

        // Create an image element
        const imageElement = document.createElement("img");

        // Set the source attribute to the static content URL
        imageElement.src = imageUrl;

        // Set some styling (optional)
        imageElement.style.maxWidth = "100%"; // Adjust based on your design

        // Append the image to the image container
        document.getElementById("imageContainer").appendChild(imageElement);
    </script>
</body>
</html>
"@

# Save the updated content to the default IIS website root directory
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value $HTMLContent -Force
