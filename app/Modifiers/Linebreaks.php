<?php

namespace App\Modifiers;

use Statamic\Modifiers\Modifier;

class Linebreaks extends Modifier
{
    /**
     * Alllow editors to control linebreaks in title/headline fields.
     *
     * @param mixed  $value    The value to be modified
     * @param array  $params   Any parameters used in the modifier
     * @param array  $context  Contextual values
     * @return mixed
     */
    public function index($value, $params, $context)
    {
        $replacements = [
            '[BR]' => '<br>',
            '[SHY]' => '&shy;',
            '[NBSP]' => '&nbsp;'
        ];

        $hide = false;

        if ($param = array_get($params, 0)) {
            $param = array_get($context, $param, $param);

            if ($param == 'hide') {
                $hide = true;
            }
        }

        foreach ($replacements as $keyword => $replacement) {
            $value = str_replace($keyword, $hide ? '' : $replacement, $value);
        }

        return $value;
    }
}
