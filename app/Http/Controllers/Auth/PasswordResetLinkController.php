<?php

namespace App\Http\Controllers\Auth;

use App\Facades\Auth\PasswordResetLinkService;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\PasswordResetLinkRequest;
use Illuminate\Http\RedirectResponse;
use Inertia\{Inertia, Response};

class PasswordResetLinkController extends Controller
{
    /**
     * Display the password reset link request view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/ForgotPassword', [
            'status' => session('status'),
        ]);
    }

    /**
     * Handle an incoming password reset link request.
     */
    public function store(PasswordResetLinkRequest $request): RedirectResponse
    {
        $status = PasswordResetLinkService::sendResetLink($request->validated());

        return back()->with('status', __($status));
    }
}
