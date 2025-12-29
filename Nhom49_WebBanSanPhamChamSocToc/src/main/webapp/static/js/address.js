const provinceSelect = document.querySelector('select[name="province"]');
const districtSelect = document.querySelector('select[name="district"]');
const wardSelect = document.querySelector('select[name="ward"]');

districtSelect.disabled = true;
wardSelect.disabled = true;

// Load tỉnh/thành
fetch('https://provinces.open-api.vn/api/p/')
    .then(res => res.json())
    .then(data => {
        provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
        data.forEach(p => {
            const opt = document.createElement('option');
            opt.value = p.code;
            opt.textContent = p.name;
            provinceSelect.appendChild(opt);
        });
    });

// Khi chọn tỉnh → load huyện
provinceSelect.addEventListener('change', () => {
    const provinceCode = provinceSelect.value;

    districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    districtSelect.disabled = true;
    wardSelect.disabled = true;

    if (provinceCode) {
        fetch(`https://provinces.open-api.vn/api/p/${provinceCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                districtSelect.disabled = false;
                data.districts.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d.code;
                    opt.textContent = d.name;
                    districtSelect.appendChild(opt);
                });
            });
    }
});

// Khi chọn huyện → load xã
districtSelect.addEventListener('change', () => {
    const districtCode = districtSelect.value;

    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    wardSelect.disabled = true;

    if (districtCode) {
        fetch(`https://provinces.open-api.vn/api/d/${districtCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                wardSelect.disabled = false;
                data.wards.forEach(w => {
                    const opt = document.createElement('option');
                    opt.value = w.code;
                    opt.textContent = w.name;
                    wardSelect.appendChild(opt);
                });
            });
    }
});
