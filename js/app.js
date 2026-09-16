(function (window) {
  var ua = navigator.userAgent || "";

  window.z7 = {
    mobile: {
      android: function () {
        return /Android/i.test(ua);
      },
      ios: function () {
        return /iPhone|iPad|iPod/i.test(ua);
      }
    }
  };

  function isSafari() {
    return (
      navigator.vendor &&
      navigator.vendor.indexOf("Apple") > -1 &&
      ua.indexOf("CriOS") === -1 &&
      ua.indexOf("FxiOS") === -1
    );
  }

  function setRem() {
    document.documentElement.style.fontSize =
      (document.documentElement.clientWidth * 20) / 320 + "px";
  }

  window.play_now_url = function () {
    window.open("https://game.lasvegassweeps777.com/", "_blank");
    return false;
  };

  window.addEventListener("resize", setRem);
  window.addEventListener("DOMContentLoaded", function () {
    setRem();
    var btn = document.querySelector(".downloadButton");
    if (btn) {
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        play_now_url();
      });
    }
    var confirmBtn = document.querySelector(".popup-button");
    if (confirmBtn) {
      confirmBtn.addEventListener("click", function () {
        document.querySelector(".popup").classList.add("hidden");
      });
    }
  });
})(window);
