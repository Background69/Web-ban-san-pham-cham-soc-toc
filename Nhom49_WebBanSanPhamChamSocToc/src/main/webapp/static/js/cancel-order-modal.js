(function () {
    'use strict';

    var modal          = document.getElementById('cancelOrderModal');
    if (!modal) return;

    var backdrop       = modal.querySelector('.cancel-order-modal__backdrop');
    var btnKeep        = document.getElementById('cancelModalBtnKeep');
    var btnConfirm     = document.getElementById('cancelModalBtnConfirm');
    var btnClose       = document.getElementById('cancelModalBtnClose');
    var radioInputs    = modal.querySelectorAll('input[name="cancelReason"]');
    var otherTextWrap  = document.getElementById('cancelReasonOtherWrap');
    var otherTextarea  = document.getElementById('cancelReasonOtherText');
    var errorMsg       = document.getElementById('cancelModalError');
    var hiddenForm     = document.getElementById('cancelOrderHiddenForm');
    var hiddenReason   = document.getElementById('cancelOrderHiddenReason');
    var currentOrderId  = null;
    var currentCancelUrl = null;
    var isClosing       = false;

    function openModal(orderId, cancelActionUrl) {
        currentOrderId   = orderId;
        currentCancelUrl = cancelActionUrl;
        resetModal();

        if (hiddenForm) {
            hiddenForm.action = cancelActionUrl;
        }

        modal.classList.add('is-visible');
        modal.classList.remove('is-closing');
        document.body.style.overflow = 'hidden';

        setTimeout(function () {
            if (btnKeep) btnKeep.focus();
        }, 400);
    }

    function closeModal() {
        if (isClosing) return;
        isClosing = true;

        modal.classList.add('is-closing');

        setTimeout(function () {
            modal.classList.remove('is-visible', 'is-closing');
            document.body.style.overflow = '';
            isClosing = false;
            resetModal();
        }, 320);
    }

    function resetModal() {
        radioInputs.forEach(function (radio) {
            radio.checked = false;
        });

        if (otherTextWrap) {
            otherTextWrap.classList.remove('is-expanded');
        }
        if (otherTextarea) {
            otherTextarea.value = '';
        }

        hideError();
    }

    function showError(message) {
        if (!errorMsg) return;
        var textEl = errorMsg.querySelector('span');
        if (textEl) textEl.textContent = message;
        errorMsg.classList.add('is-visible');
    }

    function hideError() {
        if (!errorMsg) return;
        errorMsg.classList.remove('is-visible');
    }

    function getSelectedReason() {
        var selectedRadio = null;
        radioInputs.forEach(function (radio) {
            if (radio.checked) selectedRadio = radio;
        });

        if (!selectedRadio) return null;

        var value = selectedRadio.value;
        if (value === 'other') {
            var customText = otherTextarea ? otherTextarea.value.trim() : '';
            return customText || 'Lý do khác';
        }
        return value;
    }

    function handleConfirmCancel() {
        var reason = getSelectedReason();

        if (!reason) {
            showError('Vui lòng chọn một lý do hủy đơn để chúng tôi cải thiện dịch vụ.');
            var reasonsContainer = modal.querySelector('.cancel-order-modal__reasons');
            if (reasonsContainer) {
                reasonsContainer.style.animation = 'none';
                reasonsContainer.offsetHeight;
                reasonsContainer.style.animation = 'cancelIconShake 0.5s ease';
                setTimeout(function () {
                    reasonsContainer.style.animation = '';
                }, 500);
            }
            return;
        }
        hideError();

        if (hiddenReason) {
            hiddenReason.value = reason;
        }

        if (hiddenForm) {
            hiddenForm.submit();
        }
    }

    function handleReasonChange(e) {
        hideError();

        var isOther = e.target.value === 'other';
        if (otherTextWrap) {
            if (isOther) {
                otherTextWrap.classList.add('is-expanded');
                setTimeout(function () {
                    if (otherTextarea) otherTextarea.focus();
                }, 350);
            } else {
                otherTextWrap.classList.remove('is-expanded');
            }
        }
    }
    radioInputs.forEach(function (radio) {
        radio.addEventListener('change', handleReasonChange);
    });
    if (btnKeep) {
        btnKeep.addEventListener('click', function (e) {
            e.preventDefault();
            closeModal();
        });
    }
    if (btnConfirm) {
        btnConfirm.addEventListener('click', function (e) {
            e.preventDefault();
            handleConfirmCancel();
        });
    }

    if (btnClose) {
        btnClose.addEventListener('click', function (e) {
            e.preventDefault();
            closeModal();
        });
    }

    if (backdrop) {
        backdrop.addEventListener('click', function () {
            closeModal();
        });
    }
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && modal.classList.contains('is-visible')) {
            closeModal();
        }
    });
    function interceptCancelButtons() {
        var cancelForms = document.querySelectorAll('form[action*="/cancel"]');
        cancelForms.forEach(function (form) {
            var cancelBtn = form.querySelector('button[type="submit"], input[type="submit"]');
            if (!cancelBtn) return;
            var actionUrl = form.getAttribute('action');
            var orderIdMatch = actionUrl.match(/\/orders\/(\d+)\/cancel/);
            var orderId = orderIdMatch ? orderIdMatch[1] : null;
            cancelBtn.removeAttribute('onclick');

            cancelBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                openModal(orderId, actionUrl);
            });

            form.addEventListener('submit', function (e) {
                e.preventDefault();
                e.stopPropagation();
                openModal(orderId, actionUrl);
            });
        });
    }
    interceptCancelButtons();
})();