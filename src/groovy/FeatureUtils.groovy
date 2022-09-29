class FeatureUtils {

    static boolean isInContainer() {
        return System.getenv('ETUDE_IN_DOCKER')=="1"
    }
}
