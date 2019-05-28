package noman.weekcalendar.eventbus;

import org.joda.time.DateTime;

/**
 * Created by nor on 12/5/2015.
 */
public class Event {
    public static class OnDateClickEvent {
        public OnDateClickEvent(DateTime dateTime) {
            this.dateTime = dateTime;
        }

        private DateTime dateTime;

        public DateTime getDateTime() {
            return dateTime;
        }
    }

    public static class InvalidateEvent {
    }

    public static class UpdateSelectedDateEvent {
        /***
         * Direction -1 for backgroun and 1 for forward
         *
         * @param direction
         */
        public UpdateSelectedDateEvent(int direction) {
            this.direction = direction;
        }

        public int getDirection() {
            return direction;
        }

        private int direction;
    }

    public static class SetCurrentPageEvent {
        public int getDirection() {
            return direction;
        }

        public SetCurrentPageEvent(int direction) {

            this.direction = direction;
        }

        private int direction;
    }


    public static class JumpDateEvent {
        public JumpDateEvent(DateTime selectedDate) {
            this.selectedDate = selectedDate;
        }

        public DateTime getSelectedDate() {
            return selectedDate;
        }

        private DateTime selectedDate;
    }

    public static class UrlJumpDataEvent{
        private String url;

        public UrlJumpDataEvent(String url) {
            this.url = url;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }

}
