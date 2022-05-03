@{
    # input directory
    inputDirectory = "C:\temp"
    fileExtension = "*.avi"
    encodeVideoCodec = "libx264"
    encodeCrf = "28"
    encodePreset = "veryfast"
    processorAffinity = "1111" # input representation on cores to be used
    priorityClass = "BelowNormal" # Idle, Normal, High, AboveNormal, BelowNormal, RealTime
}