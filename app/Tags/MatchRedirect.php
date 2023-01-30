<?php

namespace App\Tags;

use Illuminate\Support\Collection;
use Statamic\Entries\Entry;
use Statamic\Facades\GlobalSet;
use Statamic\Facades\Site;
use Statamic\Support\Str;
use Statamic\Tags\Concerns;
use Statamic\Tags\Tags;

class MatchRedirect extends Tags
{
    use Concerns\OutputsItems;

    /**
     * The {{ match_redirect url='{url_you_want_to_match}' }} tag.
     *
     * @return string|array
     */
    public function index()
    {
        $urlToMatch = $this->params->get('url');
        $redirects = $this->fetchRedirectsFromGlobalSet();

        if ($directMatch = $redirects->firstWhere('url_old', $urlToMatch)) {
            return $this->output($this->resolveEntryUrl($directMatch));
        }

        $wildcards = $redirects
            ->filter(fn ($redirect) => $this->isWildcard($redirect['url_old']))
            ->filter(fn ($redirect) =>$this->isMatchingWildcard($redirect['url_old'], $urlToMatch));

        // Return false in case no wildcards could be found.
        if ($wildcards->count() === 0) {
            return false;
        }

        return $this->output($this->resolveEntryUrl($wildcards->first()));
    }

    public function resolveEntryUrl(array $directMatch): array
    {
        // If it's an external link, we can't resole the Entry as there is none.
        if ($directMatch['url_type'] === 'external') {
            return $directMatch;
        }

        return array_merge($directMatch, [
            'url' => Entry::find($directMatch['entry'])->url() ?? '/',
        ]);
    }

    /**
     * Fetching all routes from the Global set as defined in the Tag.
     */
    public function fetchRedirectsFromGlobalSet(): Collection
    {
        $redirects = collect();

        foreach (Site::all()->keys()->toArray() as $site) {
            $set = GlobalSet::findByHandle($this->params->get('globalset') ?? 'redirects')
                ->in($site)
                ->data()
                ->get('redirects');

            collect($set)->each(fn ($redirect) => $redirects->push($redirect))->unique('url_old');
        }

        return $redirects;
    }

    /**
     * An url is a wildcard if containing a `*`.
     */
    public function isWildcard(string $url)
    {
        return Str::contains($url, '*');
    }

    /**
     * If the url we want to match does match a wildcard,
     * we'll return it.
     */
    public function isMatchingWildcard($url, $urlToMatch): bool
    {
        $wildcardRoute = Str::before($url, '*');

        return Str::startsWith($urlToMatch, $wildcardRoute);
    }
}
