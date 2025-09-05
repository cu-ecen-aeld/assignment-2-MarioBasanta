#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <string.h>

int main(int argc, char *argv[]) {
    openlog("writer", LOG_PID, LOG_USER);

    // Check for required arguments
    if (argc != 3) {
        syslog(LOG_ERR, "Invalid number of arguments. Usage: %s <file> <string>", argv[0]);
        closelog();
        return 1;
    }

    const char *filepath = argv[1];
    const char *writestr = argv[2];

    // Open file for writing
    FILE *fp = fopen(filepath, "w");
    if (fp == NULL) {
        syslog(LOG_ERR, "Failed to open file: %s", filepath);
        closelog();
        return 1;
    }

    // Write string to file
    if (fprintf(fp, "%s", writestr) < 0) {
        syslog(LOG_ERR, "Failed to write to file: %s", filepath);
        fclose(fp);
        closelog();
        return 1;
    }

    fclose(fp);

    // Log success message
    syslog(LOG_DEBUG, "Writing \"%s\" to \"%s\"", writestr, filepath);

    closelog();
    return 0;
}
