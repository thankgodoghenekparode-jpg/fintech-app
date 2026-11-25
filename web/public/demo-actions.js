(() => {
  if (window.__designDemoActionsInstalled) return;
  window.__designDemoActionsInstalled = true;

  const style = document.createElement('style');
  style.textContent = `
    #design-demo-toast{position:fixed;z-index:2147483647;left:50%;bottom:22px;transform:translate(-50%,16px);max-width:min(92vw,520px);padding:12px 16px;border-radius:12px;background:#241f20;color:#fff;font:500 14px/1.4 system-ui,sans-serif;box-shadow:0 8px 28px #0004;opacity:0;pointer-events:none;transition:opacity .18s,transform .18s}
    #design-demo-toast.visible{opacity:1;transform:translate(-50%,0)}
    #design-demo-dialog{max-width:min(92vw,440px);border:0;border-radius:18px;padding:24px;color:#241f20;box-shadow:0 20px 70px #0005;font:15px/1.5 system-ui,sans-serif}
    #design-demo-dialog::backdrop{background:#16111288}
    #design-demo-dialog button{margin-top:18px;padding:10px 18px;border:0;border-radius:10px;background:#7a2145;color:white;font-weight:700;cursor:pointer}
    .demo-selected-control{outline:2px solid #8e1b4a!important;outline-offset:-2px!important}
  `;
  document.head.appendChild(style);

  // The supplied designs sometimes ship disabled primary buttons to depict
  // unavailable states. In demo mode let them receive a tap so we can explain
  // the missing precondition without performing the represented operation.
  for (const button of document.querySelectorAll('button:disabled')) {
    button.dataset.demoWasDisabled = 'true';
    button.disabled = false;
    button.removeAttribute('aria-disabled');
    for (const className of [...button.classList]) {
      if (className === 'cursor-not-allowed' || /^opacity-/.test(className)) {
        button.classList.remove(className);
      }
    }
  }
  for (const item of document.querySelectorAll('.cursor-pointer')) {
    if (!(item instanceof HTMLElement) || item.matches('a,button,input,select,textarea,[role]') || item.closest('label,a,button')) continue;
    if (!/^(DIV|ARTICLE|SECTION|TR)$/.test(item.tagName) || item.querySelector('input,select,textarea,button,a')) continue;
    if (item.tagName !== 'TR') item.setAttribute('role', 'button');
    if (item.tabIndex < 0) item.tabIndex = 0;
  }

  const toast = document.createElement('div');
  toast.id = 'design-demo-toast';
  toast.setAttribute('role', 'status');
  toast.setAttribute('aria-live', 'polite');
  document.body.appendChild(toast);
  let toastTimer;

  function notify(message) {
    toast.textContent = message;
    toast.classList.add('visible');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove('visible'), 2600);
  }

  function navigateDemo(destination) {
    const message = `design-demo-navigation:${destination}`;
    if (window.DesignDemoNavigation?.postMessage) {
      window.DesignDemoNavigation.postMessage(destination);
    } else if (window.parent !== window) {
      window.parent.postMessage(message, '*');
    }
  }

  // These destinations follow the supplied screen inventory and Stitch flows.
  // Actions that move money or change account state stay on the current screen
  // and receive the safe demo confirmation below.
  function routeForAction(screenId, label) {
    const text = label.toLowerCase().replace(/&amp;/g, '&').replace(/\s+/g, ' ').trim();
    const routes = {
      'S-AGT-001': [
        [/start deposit|cash.?in/i, '/agent/cash-in'],
        [/redeem code|cash.?out/i, '/agent/cash-out'],
        [/top up/i, '/agent/float'],
        [/earnings|view all/i, '/agent/history'],
        [/day.?end/i, '/agent/day-end'],
      ],
      'S-AGT-010': [[/cash.?out code/i, '/agents/cash-out']],
      'S-AGT-012': [[/find nearest agent/i, '/agents/nearby']],
      'S-AGT-013': [[/skip.*return home/i, '/design-preview/S-AGT-001']],
      'S-AJO-001': [
        [/create circle/i, '/ajo/new'],
        [/join with code/i, '/ajo/join'],
      ],
      'S-AJO-005': [[/view receipt/i, '/ajo/demo/rounds/current']],
      'S-AJO-006': [[/pay early now/i, '/ajo/demo/pay']],
      'S-AJO-012': [[/report a concern/i, '/ajo/demo/report']],
      'S-COOP-001': [
        [/create society|create cooperative/i, '/coop/new'],
        [/join with code/i, '/coop/join'],
      ],
      'S-COOP-004': [
        [/contribute|pay early/i, '/coop/demo/contributions'],
        [/shares/i, '/coop/demo/shares'],
        [/borrow/i, '/coop/demo/loans'],
        [/statement/i, '/coop/demo/statement'],
        [/rsvp|agenda/i, '/coop/demo/hub'],
        [/view all/i, '/coop/demo/hub'],
      ],
      'S-COOP-005': [
        [/pay .* now/i, '/coop/demo/contributions/pay'],
        [/statement/i, '/coop/demo/statement'],
      ],
      'S-COOP-008': [
        [/request a new loan/i, '/coop/demo/loans/new'],
        [/make repayment/i, '/coop/demo/loans/sample-loan/repay'],
        [/view detail/i, '/coop/demo/loans/sample-loan'],
      ],
      'S-COOP-009': [[/choose .* guarantors/i, '/coop/demo/loans/new/guarantors']],
      'S-COOP-012': [[/make repayment/i, '/coop/demo/loans/sample-loan/repay']],
      'S-REV-001': [[/set up auto.?pay/i, '/dues/autopay']],
      'S-REV-002': [[/isn.t mine|dispute/i, '/dues/sample-bill/dispute']],
      'S-REV-009': [[/select payer/i, '/collect/sample-payer']],
      'S-TGT-001': [
        [/create new goal/i, '/targets/new'],
        [/goal insights/i, '/targets/demo/whatif'],
      ],
      'S-TGT-003': [
        [/add money/i, '/targets/demo/add'],
        [/withdraw/i, '/targets/demo/withdraw'],
        [/edit goal/i, '/targets/demo/edit'],
      ],
      'S-TGT-006': [[/keep my goal/i, '/targets/demo']],
      'S-TGT-008': [[/turn this simulation into a goal/i, '/targets/new']],
      'W-AGT-001': [
        [/float|reconciliation/i, '/demo-preview/W-AGT-002'],
        [/commission|limits|configuration/i, '/demo-preview/W-AGT-003'],
      ],
      'W-AGT-002': [
        [/agent management|agents/i, '/demo-preview/W-AGT-001'],
        [/commission|limits|configuration/i, '/demo-preview/W-AGT-003'],
      ],
      'W-AGT-003': [
        [/agent management|agents/i, '/demo-preview/W-AGT-001'],
        [/float|reconciliation/i, '/demo-preview/W-AGT-002'],
      ],
      'W-COOP-001': [
        [/members/i, '/demo-preview/W-COOP-002'],
        [/join requests/i, '/demo-preview/W-COOP-003'],
        [/contributions|plans/i, '/demo-preview/W-COOP-004'],
        [/loan applications/i, '/demo-preview/W-COOP-005'],
        [/loan portfolio|loans/i, '/demo-preview/W-COOP-006'],
        [/shares|dividends/i, '/demo-preview/W-COOP-007'],
        [/rules|settings/i, '/demo-preview/W-COOP-008'],
        [/admins|roles/i, '/demo-preview/W-COOP-009'],
        [/reports|ledger/i, '/demo-preview/W-COOP-010'],
        [/withdrawals/i, '/demo-preview/W-COOP-011'],
        [/announcements|meetings/i, '/demo-preview/W-COOP-012'],
        [/audit/i, '/demo-preview/W-COOP-013'],
        [/verification|trust/i, '/demo-preview/W-COOP-014'],
      ],
      'W-COOP-002': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-003': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-004': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-005': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-006': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-007': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-008': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-009': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-010': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-011': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-012': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-013': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-COOP-014': [[/dashboard/i, '/demo-preview/W-COOP-001']],
      'W-REV-001': [
        [/revenue items/i, '/demo-preview/W-REV-002'],
        [/payers/i, '/demo-preview/W-REV-003'],
        [/collections|reconciliation/i, '/demo-preview/W-REV-004'],
        [/field collectors/i, '/demo-preview/W-REV-005'],
        [/settlement|fees/i, '/demo-preview/W-REV-006'],
        [/reports/i, '/demo-preview/W-REV-007'],
        [/verification|team/i, '/demo-preview/W-REV-008'],
      ],
      'W-REV-002': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-003': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-004': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-005': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-006': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-007': [[/dashboard/i, '/demo-preview/W-REV-001']],
      'W-REV-008': [[/dashboard/i, '/demo-preview/W-REV-001']],
    };
    const sharedRoutes = screenId.startsWith('W-COOP-') ? [
      [/dashboard/i, '/demo-preview/W-COOP-001'],
      [/members/i, '/demo-preview/W-COOP-002'],
      [/join requests/i, '/demo-preview/W-COOP-003'],
      [/contributions|plans/i, '/demo-preview/W-COOP-004'],
      [/loan applications/i, '/demo-preview/W-COOP-005'],
      [/loan portfolio|loans/i, '/demo-preview/W-COOP-006'],
      [/shares|dividends/i, '/demo-preview/W-COOP-007'],
      [/rules|settings/i, '/demo-preview/W-COOP-008'],
      [/admins|roles/i, '/demo-preview/W-COOP-009'],
      [/reports|ledger/i, '/demo-preview/W-COOP-010'],
      [/withdrawals/i, '/demo-preview/W-COOP-011'],
      [/announcements|meetings/i, '/demo-preview/W-COOP-012'],
      [/audit/i, '/demo-preview/W-COOP-013'],
      [/verification|trust/i, '/demo-preview/W-COOP-014'],
    ] : screenId.startsWith('W-REV-') ? [
      [/dashboard/i, '/demo-preview/W-REV-001'],
      [/revenue items/i, '/demo-preview/W-REV-002'],
      [/payers/i, '/demo-preview/W-REV-003'],
      [/collections|reconciliation/i, '/demo-preview/W-REV-004'],
      [/field collectors/i, '/demo-preview/W-REV-005'],
      [/settlement|fees/i, '/demo-preview/W-REV-006'],
      [/reports/i, '/demo-preview/W-REV-007'],
      [/verification|team/i, '/demo-preview/W-REV-008'],
    ] : screenId.startsWith('W-AGT-') ? [
      [/agent management|agents/i, '/demo-preview/W-AGT-001'],
      [/float|reconciliation/i, '/demo-preview/W-AGT-002'],
      [/commission|limits|configuration/i, '/demo-preview/W-AGT-003'],
    ] : [];
    return [...(routes[screenId] || []), ...sharedRoutes]
      .find(([pattern]) => pattern.test(text))?.[1];
  }

  function labelOf(element) {
    const ariaLabel = element.getAttribute('aria-label');
    if (ariaLabel) return ariaLabel.replace(/\s+/g, ' ').trim();
    const textElement = element.cloneNode(true);
    textElement.querySelectorAll('.material-symbols-outlined,.material-symbols-rounded,.material-icons,.material-icons-outlined')
      .forEach((icon) => icon.remove());
    return (textElement.textContent || element.value || element.title || 'This control')
      .replace(/\s+/g, ' ').trim();
  }

  function setTab(tab) {
    const group = tab.closest('[role="tablist"]') || tab.parentElement;
    if (!group) return;
    const tabs = [...group.querySelectorAll('[role="tab"],button[aria-selected]')];
    for (const item of tabs) {
      const active = item === tab;
      item.setAttribute('aria-selected', String(active));
      item.setAttribute('aria-pressed', String(active));
      item.classList.toggle('demo-active-tab', active);
      if (active) item.classList.add('ring-2', 'ring-primary');
      else item.classList.remove('ring-2', 'ring-primary');
      const panelId = item.getAttribute('aria-controls');
      if (panelId) {
        const panel = document.getElementById(panelId);
        if (panel) panel.hidden = !active;
      }
    }
    notify(`${labelOf(tab)} selected in this demo.`);
  }

  function applyAmount(button) {
    const raw = labelOf(button);
    const match = raw.match(/[\d,]+(?:\.\d+)?/);
    if (!match) return false;
    const container = button.closest('form') || button.parentElement?.parentElement || document;
    const field = container.querySelector('input[type="number"],input[inputmode="decimal"],input[name*="amount" i]')
      || document.querySelector('input[type="number"],input[inputmode="decimal"],input[name*="amount" i]');
    if (!field) return false;
    field.value = match[0].replace(/,/g, '');
    field.dispatchEvent(new Event('input', { bubbles: true }));
    field.dispatchEvent(new Event('change', { bubbles: true }));
    notify(`${raw} filled into the amount field.`);
    return true;
  }

  function showActionDialog(label, message = 'This is a supplied design demo. No payment, transfer, approval, account update, or backend request was made.') {
    let backdrop = document.getElementById('design-demo-dialog-backdrop');
    if (!backdrop) {
      backdrop = document.createElement('div');
      backdrop.id = 'design-demo-dialog-backdrop';
      backdrop.setAttribute('role', 'presentation');
      backdrop.style.cssText = 'position:fixed;inset:0;z-index:2147483646;display:flex;align-items:center;justify-content:center;padding:20px;background:#16111288;';
      backdrop.innerHTML = '<section id="design-demo-dialog" role="dialog" aria-modal="true" aria-labelledby="design-demo-dialog-title" style="box-sizing:border-box;width:min(100%,440px);border-radius:18px;padding:24px;background:#fff;color:#241f20;box-shadow:0 20px 70px #0005;font:15px/1.5 system-ui,sans-serif"><strong id="design-demo-dialog-title" style="display:block;font-size:18px"></strong><p id="design-demo-dialog-message"></p><button id="design-demo-dialog-close" type="button" style="margin-top:12px;padding:10px 18px;border:0;border-radius:10px;background:#7a2145;color:white;font-weight:700;cursor:pointer">Close preview</button></section>';
      backdrop.addEventListener('click', (event) => {
        if (event.target === backdrop) backdrop.remove();
      });
      document.body.appendChild(backdrop);
    }
    backdrop.querySelector('#design-demo-dialog-title').textContent = label;
    backdrop.querySelector('#design-demo-dialog-message').textContent = message;
    backdrop.querySelector('#design-demo-dialog-close').focus();
  }

  function showFilterDialog(control) {
    const screenId = window.__designDemoScreenId || '';
    let choices = [];
    if (screenId === 'S-REV-001') {
      choices = [...document.querySelectorAll('main section button')].slice(0, 4);
    } else if (screenId === 'S-COOP-015') {
      choices = [...document.querySelectorAll('header button')]
        .filter((button) => /announcements|meetings|minutes/i.test(labelOf(button)));
    } else if (screenId === 'S-AGT-010') {
      const chipGroup = [...document.querySelectorAll('button')].find((button) => /within 1 km/i.test(labelOf(button)))?.parentElement;
      choices = chipGroup ? [...chipGroup.querySelectorAll('button')] : [];
    }
    choices = choices.filter((choice) => labelOf(choice));
    if (!choices.length) {
      notify('No filter choices are supplied on this screen.');
      return;
    }

    document.getElementById('design-demo-filter-backdrop')?.remove();
    const backdrop = document.createElement('div');
    backdrop.id = 'design-demo-filter-backdrop';
    backdrop.setAttribute('role', 'presentation');
    backdrop.style.cssText = 'position:fixed;inset:0;z-index:2147483646;display:flex;align-items:center;justify-content:center;padding:20px;background:#16111288;';
    const panel = document.createElement('section');
    panel.setAttribute('role', 'dialog');
    panel.setAttribute('aria-modal', 'true');
    panel.setAttribute('aria-label', 'Filter options');
    panel.style.cssText = 'box-sizing:border-box;width:min(100%,440px);max-height:85vh;overflow:auto;border-radius:18px;padding:22px;background:#fff;color:#241f20;box-shadow:0 20px 70px #0005;font:15px/1.5 system-ui,sans-serif';
    const heading = document.createElement('strong');
    heading.textContent = 'Filter options';
    heading.style.cssText = 'display:block;font-size:18px;margin-bottom:10px';
    panel.appendChild(heading);
    const help = document.createElement('p');
    help.textContent = 'Choose one of the filters shown in this supplied design. Your selection stays in this demo.';
    panel.appendChild(help);
    const optionButtons = choices.map((choice) => {
      const button = document.createElement('button');
      button.type = 'button';
      button.textContent = labelOf(choice);
      button.setAttribute('aria-pressed', 'false');
      button.style.cssText = 'display:block;width:100%;text-align:left;margin:8px 0;padding:12px 14px;border:1px solid #eadde1;border-radius:10px;background:#fff;color:#241f20;cursor:pointer';
      button.addEventListener('click', () => {
        for (const option of optionButtons) {
          const active = option === button;
          option.setAttribute('aria-pressed', String(active));
          option.style.background = active ? '#f8e8ee' : '#fff';
          option.style.borderColor = active ? '#8e1b4a' : '#eadde1';
        }
      });
      panel.appendChild(button);
      return button;
    });
    const footer = document.createElement('div');
    footer.style.cssText = 'display:flex;justify-content:flex-end;gap:8px;margin-top:16px';
    const close = document.createElement('button');
    close.type = 'button';
    close.textContent = 'Close';
    close.style.cssText = 'padding:10px 18px;border:0;border-radius:10px;background:#7a2145;color:white;font-weight:700;cursor:pointer';
    close.addEventListener('click', () => backdrop.remove());
    const apply = document.createElement('button');
    apply.type = 'button';
    apply.textContent = 'Apply filter';
    apply.style.cssText = 'padding:10px 18px;border:0;border-radius:10px;background:#7a2145;color:white;font-weight:700;cursor:pointer';
    apply.addEventListener('click', () => {
      const index = optionButtons.findIndex((option) => option.getAttribute('aria-pressed') === 'true');
      if (index < 0) {
        notify('Choose a filter first.');
        return;
      }
      const selected = choices[index];
      if (screenId === 'S-REV-001' && /paid history/i.test(labelOf(selected))) {
        navigateDemo('paid-history');
      } else {
        selected.click();
        selected.setAttribute('aria-pressed', 'true');
        selected.classList.add('demo-selected-control');
        for (const sibling of selected.parentElement?.querySelectorAll('button') || []) {
          const active = sibling === selected;
          sibling.setAttribute('aria-pressed', String(active));
          sibling.classList.toggle('ring-2', active);
          sibling.classList.toggle('ring-primary', active);
        }
        notify(`${labelOf(selected)} selected in this demo.`);
      }
      backdrop.remove();
    });
    footer.append(close, apply);
    panel.appendChild(footer);
    backdrop.appendChild(panel);
    backdrop.addEventListener('click', (event) => { if (event.target === backdrop) backdrop.remove(); });
    document.body.appendChild(backdrop);
    optionButtons[0]?.focus();
  }

  const handledClicks = new WeakSet();

  function filterItems(query, scope = document) {
    const normalized = query.toLowerCase().trim();
    const items = [...scope.querySelectorAll('tbody tr, [role="listitem"], [data-filter-item], ul > li')];
    if (!items.length) return 0;
    for (const item of items) {
      const original = item.dataset.demoOriginalDisplay;
      if (original !== undefined) item.style.display = original;
      else item.dataset.demoOriginalDisplay = item.style.display;
      item.hidden = Boolean(normalized) && !item.innerText.toLowerCase().includes(normalized);
    }
    return items.filter((item) => !item.hidden).length;
  }

  async function handleClick(event) {
    if (handledClicks.has(event)) return;
    handledClicks.add(event);
    const target = event.target instanceof Element ? event.target : null;
    if (!target) return;
    if (target.closest('#design-demo-filter-backdrop')) return;
    if (target.closest('#design-demo-dialog-close')) {
      event.preventDefault();
      document.getElementById('design-demo-dialog-backdrop')?.remove();
      return;
    }
    const control = target.closest('button,a,[role="tab"],[role="button"],input[type="button"],input[type="submit"],.cursor-pointer');
    if (!control) return;
    const label = labelOf(control);
    const iconName = control.querySelector('.material-symbols-outlined,.material-symbols-rounded,.material-icons,.material-icons-outlined')?.textContent?.trim();
    if (/filter|tune/i.test(`${label} ${iconName || ''}`)) {
      event.preventDefault();
      showFilterDialog(control);
      return;
    }
    if (iconName === 'arrow_back') {
      event.preventDefault();
      navigateDemo('back');
      return;
    }

    const nav = control.closest('nav');
    if (nav && (control instanceof HTMLAnchorElement || control instanceof HTMLButtonElement)) {
      const tabName = control.querySelector('.font-caption')?.textContent?.trim() || label;
      if (/^(home|payments|cards|save\s*&\s*borrow|more)$/i.test(tabName)) {
        event.preventDefault();
        for (const item of nav.querySelectorAll('a,button')) {
          const active = item === control;
          item.setAttribute('aria-current', active ? 'page' : 'false');
          item.classList.toggle('demo-active-tab', active);
          if (active) {
            item.classList.remove('text-on-surface-variant', 'font-normal', 'font-medium');
            item.classList.add('text-primary', 'font-semibold');
          } else {
            item.classList.remove('text-primary', 'font-semibold');
            item.classList.add('text-on-surface-variant', 'font-normal');
          }
        }
        const destination = tabName.toLowerCase().replace(/\s*&\s*/, '-');
        navigateDemo(destination);
        notify(`${tabName} selected.`);
        return;
      }
    }

    const pageHeading = document.querySelector('main h1, header h1')?.textContent || '';
    if (/^(cancel|go back)$/i.test(label) && /top up float wallet/i.test(pageHeading)) {
      event.preventDefault();
      navigateDemo('cancel-float-top-up');
      return;
    }

    if (control instanceof HTMLButtonElement && /^paid history$/i.test(label)) {
      event.preventDefault();
      navigateDemo('paid-history');
      return;
    }

    if ((window.__designDemoScreenId || '') === 'S-REV-001' && /^(all dues|overdue(?: \(\d+\))?|due this month(?: \(\d+\))?)$/i.test(label)) {
      event.preventDefault();
      const filter = label.toLowerCase();
      const cards = [...document.querySelectorAll('main article')];
      let shown = 0;
      for (const card of cards) {
        const text = card.innerText.toLowerCase();
        const visible = filter === 'all dues'
          || (filter.startsWith('overdue') && /overdue|past due/i.test(text))
          || (filter.startsWith('due this month') && /due (?:soon|28 feb|this month)|feb 2027/i.test(text));
        card.hidden = !visible;
        if (visible) shown++;
      }
      const group = control.parentElement;
      for (const sibling of group?.querySelectorAll('button') || []) {
        const active = sibling === control;
        sibling.setAttribute('aria-pressed', String(active));
        sibling.classList.toggle('ring-2', active);
        sibling.classList.toggle('ring-primary', active);
      }
      notify(`${label}: ${shown} supplied sample bill${shown === 1 ? '' : 's'} shown.`);
      return;
    }

    const destination = routeForAction(window.__designDemoScreenId || '', label);
    if (destination) {
      event.preventDefault();
      navigateDemo(destination);
      return;
    }

    if (control instanceof HTMLAnchorElement) {
      event.preventDefault();
      const href = control.getAttribute('href') || '';
      if (href.startsWith('#') && href.length > 1) {
        document.getElementById(decodeURIComponent(href.slice(1)))?.scrollIntoView({ behavior: 'smooth' });
        notify(`${label}: moved to that section.`);
      } else {
        showActionDialog(label);
      }
      return;
    }
    if (control.matches('[role="tab"],button[role="tab"],button[aria-selected]')) {
      setTab(control);
      return;
    }
    if (control instanceof HTMLButtonElement && (/toggle|switch/i.test(label) || control.hasAttribute('aria-pressed'))) {
      const pressed = control.getAttribute('aria-pressed') !== 'true';
      control.setAttribute('aria-pressed', String(pressed));
      control.classList.toggle('ring-2', pressed);
      control.classList.toggle('ring-primary', pressed);
      notify(`${label}: ${pressed ? 'on' : 'off'} in this demo.`);
      return;
    }
    if (control.matches('input[type="submit"],button[type="submit"]')) return;

    const action = label.toLowerCase();
    if (/^confirm float top-up\b/i.test(action)) {
      showActionDialog(
        label,
        'This sample requires PIN confirmation and a connected account. Neither is available in the demo, so no funds were moved.',
      );
      return;
    }
    if (/copy/.test(action)) {
      const value = control.closest('button')?.parentElement?.querySelector('input,code,[data-copy-value]')?.value
        || control.getAttribute('data-copy-value');
      if (value && navigator.clipboard?.writeText) {
        try { await navigator.clipboard.writeText(value); notify('Copied to clipboard.'); }
        catch (_) { notify('Clipboard access is unavailable in this preview.'); }
      } else notify('Copy is available in the connected product; this preview has no account data to copy.');
      return;
    }
    if (/^\D{0,4}\s*[\d,]+(?:\.\d+)?\s*(k|m)?$/i.test(label)) {
      if (applyAmount(control)) return;
    }
    if (/^(clear|reset|cancel)$/i.test(label) && control.closest('form')) {
      control.closest('form').reset();
      notify('Form cleared.');
      return;
    }
    if (control.dataset.demoWasDisabled === 'true') {
      showActionDialog(`${label} — this sample control was disabled in the supplied design. No request was sent.`);
      return;
    }
    if (/^(all|pending|approved|rejected|completed|paid|overdue|active|inactive|successful|failed|today|this week|this month)$/i.test(label)) {
      const group = control.parentElement;
      if (group) {
        for (const sibling of group.querySelectorAll('button')) {
          const active = sibling === control;
          sibling.setAttribute('aria-pressed', String(active));
          sibling.classList.toggle('ring-2', active);
          sibling.classList.toggle('ring-primary', active);
        }
      }
      const count = filterItems(label.toLowerCase() === 'all' ? '' : label);
      notify(count ? `${label} filter: ${count} sample row${count === 1 ? '' : 's'} shown.` : `${label} selected; no matching sample rows.`);
      return;
    }
    if (/^(show|hide)\b.*balance|toggle.*balance/i.test(action)) {
      const balance = document.querySelector('[data-balance],#balance-amount,.balance-amount');
      if (balance) {
        const hidden = balance.dataset.demoHidden !== 'true';
        balance.dataset.demoHidden = String(hidden);
        balance.dataset.demoValue ||= balance.textContent;
        balance.textContent = hidden ? '••••••' : balance.dataset.demoValue;
        notify(hidden ? 'Balance hidden.' : 'Balance shown.');
        return;
      }
    }
    if (/^(pay|send|transfer|withdraw|approve|reject|submit|confirm|collect|create|save|delete|remove|join|request|settle|disburse|post|publish|verify|activate|deactivate|complete|continue|proceed|sign in|log in|register|apply|invite|add|upload|download|export|print|share|generate)\b/i.test(action)) {
      showActionDialog(label);
      return;
    }
    if (control.matches('.cursor-pointer,[role="button"]')) {
      control.classList.toggle('demo-selected-control');
      notify(`${label.slice(0, 96) || 'Sample item'} selected. This change is local to the read-only demo.`);
      return;
    }
    if (control.matches('button,[role="button"],input[type="button"]')) {
      if (applyAmount(control)) return;
      notify(`${label}: preview control selected; no backend request was made.`);
    }
  }

  // Direct handlers keep ordinary controls responsive even if a prototype's
  // own scripts stop propagation; delegation also covers controls added later.
  for (const control of document.querySelectorAll('button,a,[role="tab"],[role="button"],input[type="button"],input[type="submit"]')) {
    control.addEventListener('click', handleClick, true);
    if (control instanceof HTMLButtonElement && !control.onclick) {
      control.onclick = handleClick;
    }
  }
  document.addEventListener('click', handleClick, true);
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      document.getElementById('design-demo-dialog-backdrop')?.remove();
      document.getElementById('design-demo-filter-backdrop')?.remove();
    }
    if ((event.key === 'Enter' || event.key === ' ') && event.target instanceof HTMLElement && event.target.matches('.cursor-pointer[role="button"],tr.cursor-pointer')) {
      event.preventDefault();
      event.target.click();
    }
  });
  notify('Demo interactions are active.');

  document.addEventListener('submit', (event) => {
    if (event.target instanceof HTMLFormElement && event.target.method === 'dialog') return;
    event.preventDefault();
    const form = event.target;
    if (form instanceof HTMLFormElement && !form.reportValidity()) return;
    const submit = form.querySelector('button[type="submit"],input[type="submit"]');
    showActionDialog(submit ? labelOf(submit) : 'Form submitted');
  }, true);

  document.addEventListener('change', (event) => {
    const control = event.target;
    if (control instanceof HTMLInputElement && control.type === 'checkbox') {
      notify(`${labelOf(control) || control.name || 'Option'} ${control.checked ? 'enabled' : 'disabled'} in this demo.`);
    } else if (control instanceof HTMLSelectElement) {
      notify(`${control.selectedOptions[0]?.textContent || 'Option'} selected.`);
    }
  });

  document.addEventListener('input', (event) => {
    const field = event.target;
    if (!(field instanceof HTMLInputElement) && !(field instanceof HTMLTextAreaElement)) return;
    if (!/search|filter/i.test(`${field.type} ${field.name} ${field.placeholder} ${field.getAttribute('aria-label') || ''}`)) return;
    const scope = field.closest('main') || document;
    const count = filterItems(field.value, scope);
    const output = field.parentElement?.querySelector('[role="status"]');
    if (output && output !== toast) output.textContent = `${count} matching sample rows`;
  });
})();
