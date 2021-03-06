import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import Controller from '../base_controller';
import Remark from '../components/remark';

export default class extends Controller {
  connect() {
    super.connect();
    window.remark_config = window.remark_config || {};
    window.remark_config.url = 'https://radio-t.com' + location.pathname;

    render((<Remark
      site_id={window.remark_config.site_id}
      url={'https://radio-t.com' + location.pathname}
      page_title={window.remark_config.page_title}
    />), this.element);
  }
  disconnect() {
    super.disconnect();
    unmountComponentAtNode(this.element);
  }
}
