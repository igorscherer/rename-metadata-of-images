#This script changes the date of modification accordingly to the file name ex.: IMG-20240212-WA001 it will set the date of modification to 12/02/2024

$imagesPath = "PathToImagesFolder\"
$images = Get-ChildItem $imagesPath -File

#Initialize the counter for the progress bar
$i = 0

#Define an array of common image file extensions
$imageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff")

#Iterating between all the images inside of the folder
foreach ($image in $images) {
    if ( $imageExtensions -contains $image.Extension.ToLower()) {
        try {
            #Getting and formating the date from the file name
        
            $dateString = ($image -split "[-_]")[1]
            $dateObj = [DateTime]::ParseExact($dateString, "yyyyMMdd", $null)
        
            #Changing the LastWriteTime and CreationTime matching the file name
            Set-ItemProperty -Path $imagesPath$image -Name LastWriteTime -Value $dateObj
            Set-ItemProperty -Path $imagesPath$image -Name CreationTime -Value $dateObj
            
            #Incrementing counter
            $i++
            
            #Displaying the progress
            Write-Progress -Activity "Processing images . . ." -Status "Image: $i of $($images.Count)" -PercentComplete (($i / $images.Count) * 100)
        }
        catch {
            Write-Error "An error occured while renaming LastWriteTime, of the file $image"
        }
        
    }
    else{
        Write-Host "The file $image, isn't a image file, or it is using a strange extension."
    }
}
Write-Host "Properties of all images changed successfully!"
