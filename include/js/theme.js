// Dark / light theme switching. The choice is stored in localStorage; without a
// stored choice the browser preference (prefers-color-scheme) is used.
(function () {
    var KEY = 'nconf_theme';
    var root = document.documentElement;

    function stored() {
        try { return localStorage.getItem(KEY); } catch (e) { return null; }
    }

    function preferred() {
        var s = stored();
        if (s === 'dark' || s === 'light') { return s; }
        return (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light';
    }

    function apply(theme) {
        root.setAttribute('data-theme', theme);
        var toggle = document.getElementById('theme-toggle');
        if (toggle) { toggle.textContent = theme === 'dark' ? '[ Light mode ]' : '[ Dark mode ]'; }
    }

    // Apply right away (script is loaded in <head>) to avoid a flash of the light theme
    apply(preferred());

    window.nconfToggleTheme = function () {
        var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        try { localStorage.setItem(KEY, next); } catch (e) {}
        apply(next);
        return false;
    };

    document.addEventListener('DOMContentLoaded', function () { apply(root.getAttribute('data-theme')); });
})();
