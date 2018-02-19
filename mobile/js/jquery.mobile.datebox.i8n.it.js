jQuery.extend(jQuery.mobile.datebox.prototype.options.lang, {
    'it': {
        setDateButtonLabel: 'Set Date',
        setTimeButtonLabel: 'Set Time',
        setDurationButtonLabel: 'Set Duration',
        calTodayButtonLabel: 'Jump to Today',
        titleDateDialogLabel: 'Choose Date',
        titleTimeDialogLabel: 'Choose Time',
        daysOfWeek: ['Domenica', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato'],
        daysOfWeekShort: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
        monthsOfYear: ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'],
        monthsOfYearShort: ['Jan', 'Feb', 'Mar', 'Arp', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        durationLabel: ['Days', 'Hours', 'Minutes', 'Seconds'],
        durationDays: ['Day', 'Days'],
        timeFormat: 12,
        dateFieldOrder: ['d', 'm', 'y'],
        timeFieldOrder: ['h', 'i', 'a'],
        slideFieldOrder: ['y', 'm', 'd'],
        headerFormat: 'ddd, mmm dd, YYYY',
        dateFormat: 'dd/mm/YYYY',
        isRTL: false
    }
});
jQuery.extend(jQuery.mobile.datebox.prototype.options, {
    useLang: 'it'
});